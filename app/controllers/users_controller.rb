class UsersController < ApplicationController
  before_action :user_is_authorised?, except: [:create,:forgot_my_password,:send_token_email, :complete_signup, :new_token_confirmation,:validate_token,:accept], raise: false
  before_action :load_icons, only: [:show]

  def index
    @users = User.all
  end

  def show
    @apartments = current_user.apartments.includes([:amenity,:feature,:descriptor]).order(created_at: :desc).with_attached_photos
    @favourites = current_user.favourites.order(created_at: :desc).with_attached_photos
    @searches = current_user.searches.where.not("title LIKE ?","result%").order('created_at DESC')
    @locations = @searches.map { |search| search.selections.pluck :name }.flatten
  rescue ArgumentError => e
    Rails.logger.error { "error: #{e}" }
    flash[:alert] = "There was an error, please try again."
    render "index"
  end

  def create
    # FIXME refactor this with scenarios eg user, username already present etc
    begin
      @user = User.find_by(email: user_params[:email])
      if @user.present?
        flash[:user_params] = user_params
        redirect_to welcome_back_user_path and return
      else
        @user = User.create!(user_params)
        @user.avatar.attach(user_params[:avatar])
        session[:user_id] = @user.id
        @user.searches.create!(session[:saved_search]) if session[:saved_search].present?
        session.delete "saved_search"
        redirect_to accept_path(@user) and return
      end
      # FIXME userscontrollerhelper not recognised
    rescue ActiveRecord::RecordNotUnique => e
      @message = "That username has been taken, please choose another username " if e.inspect.include? "(username)"
      flash[:updated_user_params] = user_params.permit(:email, :firstname, :surname, :phone)
      redirect_to mobile_signup_path(updated_params) and return
    rescue ActiveRecord::RecordInvalid => e
      errors = e.inspect.split(',')
      @message = errors.each_with_object([]) do |error, message|
        if error.include? "Password confirmation doesn't match Password"
          message << "Password confirmation doesn't match Password. Please try again."
        elsif error.include? "Username has already been taken"
          message << "Please try a different #{(error.include? 'Password') ? 'Password' : 'Username'}. Please ensure it is at least 6 characters long."
        else
          message << "Please try a different #{(error.include? 'Password') ? 'Password' : 'Username'}. Please ensure it is at least 6 characters long."
        end
        flash[:updated_user_params] = user_params.permit(:email, :firstname, :surname, :phone, :username)
        Rails.logger.error {e.inspect}
        flash[:alert] = @message.join(' ')
        redirect_to mobile_signup_path and return
      end
    end
  end

  def accept
    @user = User.find(session[:user_id])
    @user.update!(accepted_terms_and_conditions:true)
    flash[:notice] = "You have registered as #{@user&.username}"
    UserMailer.with(user: @user).welcome_email.deliver_later
    notify_admin_team 'new_user_alert',
      location_info: Geocoder.search(request.remote_ip).first.data,
      email: @user.email,
      firstname: @user.firstname,
      surname: @user.surname,
      username: @user.username,
      phone: @user.phone
    redirect_to previous_page and return @user
  end

  def decline
    redirect_to logout_path
  end

  def update
    current_user.update(update_user_params)
    flash[:notice] = "Your details have been successfully updated."
  rescue StandardError => e
    Rails.logger.error { e.inspect }
    flash[:notice] = "There was a problem updating your details. Please try again later."
  ensure
    redirect_to user_path(current_user)
  end

  def forgot_my_password
  end

  def send_token_email
    @email = password_params[:email]
    @user = User.find_by_email(@email)
    if @user.present?
      @user.set_password_token(valid_for: 15.minutes)
      UserMailer.with(user_id: @user.id, request_url: request.original_url).reset_password_email.deliver_later
      message = "success"
    else
      message = "failure"
    end
    redirect_to new_token_email_path(email: @email, message: message)
  end

  def new_token_confirmation
    @email = params[:email]
    messages = {"failure":"We couldn't find any user with the email","success":"We've sent you a link to reset your password to "}
    @message = messages[params[:message].to_sym]
  end

  def validate_token
    begin
      # receives link and token and validates entry, if valid redirects to new password method
      @user = User.find_by_reset_password_token(params[:token])
      @user.present? && @user.password_token_valid_until < Time.now
      @token = params[:token]
      session[:user_id] = @user.id
      render "update_password"
    rescue Exception => e
      @message = "email address is invalid or token has expired"
      redirect_to forgot_my_password_path
    end
  end

  def update_password
    # updates password in db
    if current_user.update update_password_params
      current_user.update!(reset_password_token:nil)
      redirect_to myproperties_path, alert:  "Password successfully updated" and return
    else
      flash[:alert] = "New password & confirmation fields do not match"
    end
  end

  def change_password
    if current_user.authenticate old_password_params[:old_password]
      current_user.update new_password_params
      flash[:notice] = "Password successfully updated."
    else
      flash[:alert] = "Old password is incorrect or new password & confirmation fields do not match"
    end
    redirect_to user_path(current_user)
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete_signup
    begin
      # receives link and token and validates entry, if valid redirects to new password method
      @user = User.find_by_reset_password_token(params[:token])
      @user.present? && @user.password_token_valid_until < Time.now
      @user.milestones.update(email_address_confirmed: true)
      @token = params[:token]
      session[:user_id] = @user.id
      flash[:alert] = "Congratulations. You have successfully completed your registration."
      redirect_to user_path(@user) and return
    rescue Exception => e
      Rails.logger.error { "error: #{e}" }
      @message = "email address is invalid or token has expired"
      redirect_to forgot_my_password_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.permit(:avatar, :email, :firstname, :surname, :phone, :username, :password, :password_confirmation)
  end

  def terms_params
    params.permit(:user_id)
  end

  def password_params
    params.permit(:email)
  end

  def update_user_params
    params.permit(:email, :firstname, :surname, :phone, :username, :avatar)
  end

  def update_password_params
    params.require(:user).permit(:password,:password_confirmation)
  end

  def old_password_params
    params.require(:user).permit(:old_password)
  end
  def new_password_params
    params.require(:user).permit(:password,:password_confirmation)
  end
end
