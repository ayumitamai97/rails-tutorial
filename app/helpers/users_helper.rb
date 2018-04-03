module UsersHelper
  # def gravatar_for(user, options = { size: size }) # erbからsizeを受け取る
  #   gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  #   size = options[:size]
  #   gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  #   image_tag(gravatar_url, alt: user.name, class: "gravatar")
  # end
  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, size: 80) # sizeを直接渡す
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
