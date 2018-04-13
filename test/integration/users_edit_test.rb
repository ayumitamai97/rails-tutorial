require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael) #fixtures
    @other_user = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select "div#error_explanation ul li", count: 4 # エラーの文が4つ出ている
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {user: {name: name, email: email, password: "", password_confirmation: ""}}
    assert_not flash.empty? # パスワードを入力しなくてもエラーが出ない（これを目標にしたテスト駆動開発）
    assert_redirected_to @user
    @user.reload
    # assert_equal expected, actual
    assert_equal name, @user.name # 入力した値, DBの値
    assert_equal email, @user.email # 入力した値, DBの値
  end

  test "should be redirected to login_url when not logged_in but tried to edit" do
    get edit_user_path(@user) # users#edit
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should be redirected to login_url when not logged_in but tried to update" do
    patch user_path(@user), params:{user:{name: @user.name, email: @user.email}} # users#update
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should be redirected to root when logged in as wrong user" do
    log_in_as @other_user
    get edit_user_path(@user) # users#edit
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should be redirected to root when logged in as a wrong user" do
    log_in_as @other_user
    patch user_path(@user), params: {user: {name: @user.name, email: @user.email}}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {user: {name: name, email: email, password: "", password_confirmation: ""}}
    assert_not flash.empty? # パスワードを入力しなくてもエラーが出ない（これを目標にしたテスト駆動開発）
    assert_redirected_to @user
    @user.reload
    # assert_equal expected, actual
    assert_equal name, @user.name # 入力した値, DBの値
    assert_equal email, @user.email # 入力した値, DBの値
  end

  test "forwarded only when first access" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user) # ログイン前に:forwarding_urlに保存される
    log_in_as(@user) # ログインすると…
    assert_nil session[:forwarding_url] # 消される！
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {user: {name: name, email: email, password: "", password_confirmation: ""}}
    assert_not flash.empty? # パスワードを入力しなくてもエラーが出ない（これを目標にしたテスト駆動開発）
    assert_redirected_to @user
    @user.reload
    # assert_equal expected, actual
    assert_equal name, @user.name # 入力した値, DBの値
    assert_equal email, @user.email # 入力した値, DBの値
  end

end
