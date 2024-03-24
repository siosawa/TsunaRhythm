ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
    # 単体クラスのテスト
    # ユーザーがログインしているかどうかのテスト
  end
end

class ActionDispatch::IntegrationTest
  # 統合クラスのテスト。これはストーリーを描くテストでブラウザ上で
  # 段階を踏んだテストを行う。
  # テストユーザーとしてログインする
  # 実際にログイン情報を入力してlogin_pathにページが移動するかテスト
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password:,
                                          remember_me: } }
  end
end
