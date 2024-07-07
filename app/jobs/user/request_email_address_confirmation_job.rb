class User::RequestEmailAddressConfirmationJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    user = User.find(user_id)
    user.set_password_token(valid_for: 24.hours)
    UserMailer.with(user_id: user.id).request_email_address_confirmation.deliver_later
  end

end