require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael) # users.ymlというfixtureの:michael
  end

  test "login with invalid info" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: {email: "", password: ""}}
    assert_template"sessions/new"
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: {session: { email: @user.email, password: 'password' }} # params:をつけないとエラー
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # ログイン用リンクがなくなったことを確認
    assert_select "a[href=?]", logout_path # ログアウトリンクが出てきたことを確認
    assert_select "a[href=?]", user_path(@user)
  end

  test "login followed by logout" do
    # login
    get login_path
    post login_path, params: {session: { email: @user.email, password: 'password' }} # params:をつけないとエラー
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # ログイン用リンクがなくなったことを確認
    assert_select "a[href=?]", logout_path # ログアウトリンクが出てきたことを確認
    assert_select "a[href=?]", user_path(@user)

    # logout
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path # あえて二度目 browserだぶり
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: "1")
    # assert_not_empty cookies["remember_token"] # cookieを保存してログインするとremember_tokenが存在する
    assert_equal cookies["remember_token"], assigns(:user).remember_token # インスタンス変数に対するメソッドでremember_tokenを確認できる！
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: "1")
    delete logout_path # 一旦ログアウトしてみる
    log_in_as(@user, remember_me: "0") # cookieを削除してログイン
    assert_empty cookies["remember_token"] # cookieを削除してログインするとremember_tokenが空
  end


end
