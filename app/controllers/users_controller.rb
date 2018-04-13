class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update] # どのアクションの前にbefore_action を適用するか
  before_action :correct_user, only: [:edit, :update] # パスがそれぞれedit_userとuserとなっており異なっているため、両方保護することが必要

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # セキュリティ
    if @user.save
      log_in @user
      flash[:success] = "Welcome!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit # user作成のときのnewにあたる！
    @user = User.find(params[:id])
  end

  def update # user作成のときのcreateにあたる！
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated" # flashはこうかく
      redirect_to @user
    else
      render "edit"
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation) # セキュリティ
      # Strong Parametersを使ってマスアサインメントの脆弱性を防止
    end

    def logged_in_user # ログイン済みユーザかどうか確認
      unless logged_in?
        store_location # ユーザがアクセスしたかったURLを:forwarding_urlキーに格納しておく
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    def correct_user # current_userとの比較
      @user = User.find(params[:id])
      redirect_to (root_url) unless current_user?(@user)
    end

end
