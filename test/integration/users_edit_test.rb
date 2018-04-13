require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
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

end
