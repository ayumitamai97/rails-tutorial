class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception
  def hello
  	render html: "世界に挨拶ばっかりしてる"
  end
end
