class RelationshipsController < ApplicationController
  before_action :logged_in_user # ApplicationControllerで定義されている。継承されているため使える。
  # 逆に、どこで定義されているか調べたい時はまずどのクラスを継承しているか確認すべき。

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user) # follow user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user) # unfollow user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  # respond_toは上から順に実行する逐次処理というより、if文を使った分岐処理に近い
  # ビューで変数を使うため、変数はuserではなく@@user

end
