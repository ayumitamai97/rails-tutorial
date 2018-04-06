require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # test helper (logged_in?とは別！)
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user) # 単体テスト
    session[:user_id] = user.id
  end
end


# 統合テスト。sessionを直接取り扱うことができないので、代わりにSessionsリソースに対してpostを送信することで代用
class ActionDispatch::IntegrationTest # テストユーザとしてログイン
  def log_in_as(user, password: "password", remember_me: "1") # rememberする
    post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me}}
  end
end
