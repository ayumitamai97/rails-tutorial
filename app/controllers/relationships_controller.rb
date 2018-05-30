class RelationshipsController < ApplicationController
  before_action :logged_in_user # ApplicationControllerで定義されている。継承されているため使える。
  # 逆に、どこで定義されているか調べたい時はまずどのクラスを継承しているか確認すべき。

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user) # follow user
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user) # unfollow user
    redirect_to user
  end

end
