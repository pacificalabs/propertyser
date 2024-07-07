module ApplicationHelper
  def mobile_device
    agent = request.user_agent
    return "tablet" if agent =~ /(tablet|ipad)|(android(?!.*mobile))/
    return "mobile" if agent =~ /Mobile/
    return "desktop"
  end

  def get_aws_url(file_path)
    file_path
  end
end
