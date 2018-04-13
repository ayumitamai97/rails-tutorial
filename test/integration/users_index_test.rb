require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path # これはusers#index
    assert_template "users/index"
    assert_select "div.pagination", count: 2 # ページネーションが存在することを確認
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      # リンクの文字部分がちゃんと名前になっているか確認
    end
  end


end
