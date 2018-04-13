class UsersController < ApplicationController

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

end
