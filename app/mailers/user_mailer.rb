class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    email_with_name = %("#{@user.firstname}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Registration')
  end

  def reset_password_email
    @user = User.find(params[:user_id])
    email_with_name = %("#{@user.firstname}" <#{@user.email}>)
    token = @user.reset_password_token
    @path = "validate-token/#{token}/"
    @link = "#{params[:request_url].split('/')[0..2].join('/')}/#{@path}"
    mail(to: email_with_name, subject: "#{@user.firstname} update your password")
  end

  def request_email_address_confirmation
    @user = User.find(params[:user_id])
    email_with_name = %("#{@user.firstname}" <#{@user.email}>)
    token = @user.reset_password_token
    @path = "complete_signup/#{token}/"
    @link = "#{params[:request_url].split('/')[0..2].join('/')}/#{@path}"
    mail(to: email_with_name, subject: "#{@user.firstname} complete your registration with #{params[:request_url].split('/')[0..2].join('/')}")
  end
end
