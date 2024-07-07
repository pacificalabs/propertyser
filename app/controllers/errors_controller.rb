class ErrorsController < ApplicationController
  skip_before_action :user_is_authorised?

  def not_found
    render(:status => 404)
  rescue StandardError => e
    puts e.backtrace
  end

  def internal_server_error
    render(:status => 500)
  end
end
