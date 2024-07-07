class AdminMailer < ApplicationMailer
  default from: "Leena from Homblok <leena@homblok.com>", cc: "Support Desk <homblok@pacificasearch.com>"
  def new_user_alert
    @location_info = params[:data][:location_info]
    @email = params[:data][:email]
    @firstname = params[:data][:firstname]
    @surname = params[:data][:surname]
    @username = params[:data][:username]
    @phone = params[:data][:phone]
    @to = params[:recipient]
    mail(from: "Homblok Admin Team <leena@homblok.com>" , to: @to.email, subject: "New user alert -  #{@firstname} #{@surname}")
  end

  def contact_form
    @location_info = params[:data][:location_info]
    @message_body = params[:data][:message_body]
    @name = params[:data][:firstname]
    @phone = params[:data][:phone]
    @email = params[:data][:email]
    @subject = params[:data][:subject]
    @to = params[:recipient]
    mail(from: "Homblok Contact Us Form <leena@homblok.com>", to: @to.email, subject: "#{@subject}")
  end
end