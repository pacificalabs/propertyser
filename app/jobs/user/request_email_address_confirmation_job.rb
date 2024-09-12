class User::RequestEmailAddressConfirmationJob
  def self.perform(user_id:)
    Thread.new do
      begin
        user = User.find(user_id)
        user.set_password_token(valid_for: 24.hours)
        UserMailer.with(user_id: user.id, request_url: request.original_url).request_email_address_confirmation.deliver_later
      rescue => e
        Rails.logger.error("Error processing email confirmation request for user #{user_id}: #{e.message}")
      end
    end
  end
end
