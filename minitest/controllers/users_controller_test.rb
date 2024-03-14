require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # setupメソッドは、各テストが実行される前に呼ばれる。
# users.ymlファイルから:archerと:michaelというキーでユーザーをロードしてインスタンス変数に割り当てる。
# def setup
#   @other_user = users(:archer) 
#   @user = users(:michael)
# end  

# "should get new"は、サインアップページへのアクセステスト。
# signup_pathへのGETリクエストが成功する（HTTPステータスコード200を返す）ことを検証。
# test "should get new" do
#   get signup_path
#   assert_response :success
# end

# "should redirect index when not logged in"は、ログインしていない状態でusers_pathにアクセスした場合のテスト。
# ログインページ(login_url)へリダイレクトされることを検証。
# test "should redirect index when not logged in" do
#   get users_path
#   assert_redirected_to login_url
# end

# "should redirect destroy when not logged in"は、ログインしていない状態でユーザー削除を試みた場合のテスト。
# User.countが変化しない（ユーザーが削除されない）こと、ログインページへリダイレクトされることを検証。
test "should redirect destroy when not logged in" do
  assert_no_difference 'User.count' do
    delete user_path(@user)
  end
  assert_response :see_other
  assert_redirected_to login_url
end

# "should redirect destroy when logged in as a non-admin"は、非管理者ユーザーでログインした状態でユーザー削除を試みた場合のテスト。
# User.countが変化しないこと、root_urlへリダイレクトされることを検証。
test "should redirect destroy when logged in as a non-admin" do
  log_in_as(@other_user)
  assert_no_difference 'User.count' do
    delete user_path(@user)
  end
  assert_response :see_other
  assert_redirected_to root_url
end

# "should redirect following when not logged in"と"should redirect followers when not logged in"は、
# ログインしていない状態でフォロー中ユーザーとフォロワーのリストを表示しようとした場合のテスト。
# それぞれログインページへリダイレクトされることを検証。
test "should redirect following when not logged in" do
  get following_user_path(@user)
  assert_redirected_to login_url
end

test "should redirect followers when not logged in" do
  get followers_user_path(@user)
  assert_redirected_to login_url
end

end
