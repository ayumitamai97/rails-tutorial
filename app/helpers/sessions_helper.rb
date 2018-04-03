module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id # sessionメソッドはSessionsコントローラとは別物
  end

  def current_user
    # ローカルメソッドだといちいちDBに問い合わせてしまうため、インスタンス変数に格納する
    @current_user ||= User.find_by(id: session[:user_id]) # @current_userがnilならfind_byする
  end

  def logged_in?
    !current_user.nil?
  end
end
