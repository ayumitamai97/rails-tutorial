require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # def setup
  #   @user = users(:michael)
  # end

  # test "index including pagination" do
  #   log_in_as(@user)
  #   get users_path # これはusers#index
  #   assert_template "users/index"
  #   assert_select "div.pagination", count: 2 # ページネーションが存在することを確認
  #   User.paginate(page: 1).each do |user|
  #     assert_select "a[href=?]", user_path(user), text: user.name
  #     # リンクの文字部分がちゃんと名前になっているか確認
  #   end
  # end
  
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index' # 描画確認
    assert_select 'div.pagination' # paginateできていることを確認
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin # adminでなければ
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do # この書き方！
      delete user_path(@non_admin) # adminでdeleteできることを確認
    end
  end

  test "index as non-admin" do # adminじゃないとdeleteリンクがない
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
