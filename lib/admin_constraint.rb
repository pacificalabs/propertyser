class AdminConstraint
  require 'logger'

  def matches?(request)
    if request.session[:user_id].present?
      user = User.find request.session[:user_id]
      user.present? && user.is_admin?
    else
      return false
    end
  end
end