module UsersHelper

  def user_avatar(user)
    if user.avatar.attached?
      image_tag("https://h1.imgix.net/#{user.avatar.key}?usm=20&facepad=1.5&faceindex=1&fit=facearea&mask=ellipse&h=45&w=45&auto=enhance", class: "avatar m-1")   
    else
      image_tag(get_aws_url("white_icons/icons8-information-50.png"), class: "iconz mb-md-3 mx-1") 
    end  
  end

  def user_avatar_profile_label
    current_user.avatar.attached? ? "Change Your Profile Picture" : "Add a Profile Picture"
  end

  def profile_pic_url(user)
    "https://h1.imgix.net/#{user.avatar.key}?usm=20&h=250&w=250&auto=enhance"
  end

end
