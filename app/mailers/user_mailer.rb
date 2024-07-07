class UserMailer < ApplicationMailer
  default from: "Leena from Homblok <leena@homblok.com>", bcc: "Support Desk <homblok@pacificasearch.com>"
 
  def welcome_email
    @user = params[:user]
    email_with_name = %("#{@user.firstname}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Welcome to Homblok')
  end

  def reset_password_email
    @user = User.find(params[:user_id])
    email_with_name = %("#{@user.firstname}" <#{@user.email}>)
    token = @user.reset_password_token
    @path = "validate-token/#{token}/"
    @link = "http://homblok.herokuapp.com/#{@path}"
    mail(to: email_with_name, subject: "#{@user.firstname} update your password")
  end

  def request_email_address_confirmation
    @user = User.find(params[:user_id])
    email_with_name = %("#{@user.firstname}" <#{@user.email}>)
    token = @user.reset_password_token
    @path = "complete_signup/#{token}/"
    @link = "https://www.homblok.com/#{@path}"
    mail(to: email_with_name, subject: "#{@user.firstname} complete your registration with www.homblok.com")    
  end
end
