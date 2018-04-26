require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup info" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name:  "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }
    end
    assert_template "users/new"
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
 end

 test "invalid signup path" do # users_pathが無効であることをテスト
   get users_path
   assert_select "form", false
 end

  # test "valid signup info" do # userを作れていることをテスト
  #   assert_difference "User.count", 1 do
  #     post users_path, params: { user: { name:  "Test", email: "user@valid.com", password: "foobarr", password_confirmation: "foobarr" } }
  #   end
  #   follow_redirect!
  #   # assert is_logged_in?
  #   # assert_template 'users/show'
  #   assert_not flash.nil?
  # end

  test "valid signup info with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {user: {name: "Example", email: "user@example.com", password: "password", password_confirmation: "password"}}
    end
    # 配信されたメッセージがきっかり1つであるかどうかを確認
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    # このassignsメソッドを使うと対応するアクション内のインスタンス変数にアクセスできるようになります。例えば、Usersコントローラのcreateアクションでは@userというインスタンス変数が定義されていますが (リスト 11.23)、テストでassigns(:user)と書くとこのインスタンス変数にアクセスできるようになる、といった具合です。
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
