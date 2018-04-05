class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) # has_secure_passwordが提供するauthenticateメソッド
      log_in user
      remember user
      redirect_to user
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
