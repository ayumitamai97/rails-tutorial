require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 # リンクがHTMLに2つ存在するので
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get signup_path
    # assert_select "a[href=?]", signup_path
  end

  test "check layout links when logged in as correct user" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", user_path(@user)
  end

  test "check layout links when logged in as wrong user " do
    log_in_as(@user) # これでよいのか…
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", users_path # index
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
  end

end

# rake test:integration でテスト
