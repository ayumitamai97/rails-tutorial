class SessionsController < ApplicationController
  def new
    # debugger
  end

  def create # userというローカル変数を@userというインスタンス変数にすることでテストからassign(:user)としてインスタンス変数にアクセスできる
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password]) # has_secure_passwordが提供するauthenticateメソッド
      log_in @user
      params[:session][:remember_me] == '1'? remember(@user) : forget(@user) # remember userをおきかえた
      # もさっとしているif文を三項演算子に！ 条件? trueの場合 : falseの場合
      # redirect_to @user # これだと保護されたページにアクセスしようとしたとき自分のプロフィールに飛んでしまい不親切
      redirect_back_or @user
    else
      flash.now[:danger] = "Invalid email/password combination" # .nowをつけないflashだとエラーメッセが残留してしまう
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
