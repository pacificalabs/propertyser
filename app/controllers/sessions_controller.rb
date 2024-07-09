class SessionsController < ApplicationController
  before_action :user_is_authorised?, except: [:mobile_login,:mobile_signup,:create,:destroy,:welcome_back_user]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      user.searches.create!(session[:saved_search]) if session[:saved_search].present?
      session.delete "saved_search"
      session[:user_id] = user.id
      flash[:notice] = "Welcome back #{user&.username}"
      redirect_to previous_page
    else
      logger.error { "Email or Password is incorrect, please try again." }
      flash[:alert] = "Email or Password is incorrect, please try again."
      render action: "mobile_login" and return
    end
  end

  def destroy
    destroy_fullpath
    reset_session
    clear_notices_and_alerts
    redirect_to root_url
  end

  def mobile_login
  end

  def mobile_signup
    @user = OpenStruct.new(flash[:updated_user_params]) if flash[:updated_user_params].present?
  end

  def welcome_back_user
    redirect to root_path and return unless flash[:user_params].present?
    user_params = flash[:user_params]
    user = User.find_by_email(user_params["email"])
    if user && user.authenticate(user_params["password"])
      session[:user_id] = user.id
      flash[:notice] = "Welcome back #{+user&.firstname}. We have signed you in under your previous username #{user&.username}."
      redirect_back fallback_location: root_path
    else
      message = "The email address is registered already but the password is incorrect, please try again."
      logger.error { message }
      flash[:alert] = message
      redirect_to  mobile_login_path
    end
  end

  private
  def user_params
    params.permit(:email, :firstname, :surname, :phone, :username, :avatar)
  end

end
