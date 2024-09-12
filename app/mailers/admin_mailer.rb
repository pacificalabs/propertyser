class AdminMailer < ApplicationMailer

  def new_user_alert
    @location_info = params[:data][:location_info]
    @firstname = params[:data][:firstname]
    @surname = params[:data][:surname]
    @username = params[:data][:username]
    @phone = params[:data][:phone]
    @to = params[:recipient]
    @subject = "New user alert - #{@firstname} #{@surname}"

    mail(
      to: @to.email,
      subject: @subject
    )
  end

  def contact_form
    @location_info = params[:data][:location_info]
    @message_body = params[:data][:message_body]
    @name = params[:data][:firstname]
    @phone = params[:data][:phone]
    @email = params[:data][:email]
    @subject = params[:data][:subject]
    @to = params[:recipient]

    mail(
      from: "Contact Form <zoilism@gmail.com>",
      to: @to.email,
      subject: @subject
    )
  end
end
