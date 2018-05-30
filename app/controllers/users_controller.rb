class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers] # どのアクションの前にbefore_action を適用するか
  before_action :correct_user, only: [:edit, :update] # パスがそれぞれedit_userとuserとなっており異なっているため、両方保護することが必要
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # redirect_to root_url and return unless @user.activated?
    # not-activated userはそもそもindexに表示されないようにしたため不要
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # セキュリティ
    if @user.save
      @user.send_activation_email # user.rbで定義した
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Successfully deleted"
    redirect_to users_url
  end

  # pathに使いたいメソッドはコントローラで定義する
  # 逆に、pathに使わないメソッドはモデルで定義することが多い
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation) # セキュリティ
      # Strong Parametersを使ってマスアサインメントの脆弱性を防止
    end

    def correct_user # current_userとの比較
      @user = User.find(params[:id])
      redirect_to (root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin? # 管理者かどうか確認
      # destroyの前にこれを行う
    end

end
