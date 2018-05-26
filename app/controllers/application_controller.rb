class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception

  private

  def logged_in_user # ログイン済みユーザかどうか確認
    unless logged_in?
      store_location # ユーザがアクセスしたかったURLを:forwarding_urlキーに格納しておく
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end

end
