class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def hello
  	render html: "世界に挨拶ばっかりしてる"
  end
end
