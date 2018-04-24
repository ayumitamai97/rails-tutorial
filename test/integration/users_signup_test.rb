require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test "valid signup info" do # userを作れていることをテスト
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name:  "Test", email: "user@valid.com", password: "foobarr", password_confirmation: "foobarr" } }
    end
    follow_redirect!
    # assert is_logged_in?
    # assert_template 'users/show'
    assert_not flash.nil?
  end

end
