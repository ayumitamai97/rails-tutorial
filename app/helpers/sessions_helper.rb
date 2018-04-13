module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id # sessionメソッドはSessionsコントローラとは別物
  end

  def current_user
    # ローカルメソッドだといちいちDBに問い合わせてしまうため、インスタンス変数に格納する
    # @current_user ||= User.find_by(id: session[:user_id]) # @current_userがnilならfind_byする
    # 以上だと永続セッションを扱えないので…

    if (user_id = session[:user_id]) # セッションがすでに存在するなら
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # セッションが存在しないがクッキーが保存されているなら
      # raise # 敢えて例外処理を入れてみてテストが妥当か確かめる
      user = User.find_by(id: user_id) # userをクッキーから定義
      if user && user.authenticated?(cookies[:remember_token]) # tokenが一致するなら
        log_in user # ログインできる！
        @current_user = user
      end
    end

  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user) # ユーザのセッションを永続的にする
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user == current_user
  end

end
