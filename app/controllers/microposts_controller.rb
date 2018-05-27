class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params) # buildを使う！
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_url
    else
      @feed_items = []
      # マイクロポストの投稿が失敗すると、 Homeページは@feed_itemsインスタンス変数を期待しているため、現状では壊れてしまうので
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to root_url request.referrer || root_url
    # ここではrequest.referrerというメソッドを使っていて、一つ前のURLを返します。
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
      # 削除対象のpost(params[:id]で識別する)をログイン中のuserが保有しているか
    end
end
