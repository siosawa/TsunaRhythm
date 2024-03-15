require 'rails_helper'
# ログインの有無と画面遷移の検証
RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "RootURLにアクセスが成功する" do
      get root_path
      expect(response).to have_http_status(200)
    end

    it "/loginにアクセスが成功する" do
      get login_path
      expect(response).to have_http_status(200)
    end

    it "/signupにアクセスが成功する" do
      get signup_path
      expect(response).to have_http_status(200)
    end

    it "/usersにアクセスするがログインしていないので/loginにアクセスする" do
      get users_path
      expect(response).to redirect_to(login_url)
    end

    it "ログインしていない状態でユーザーをフォローすると/loginにアクセスする" do
      expect {
        post relationships_path
      }.to_not change(Relationship, :count)
      expect(response).to redirect_to(login_url)
    end

    it "ログインしていない状態でポストを作成しようとすると/loginにアクセスする" do
      expect {
        post microposts_path, params: { micropost: { content: "おはよう" } }
      }.to_not change(Micropost, :count)
      expect(response).to redirect_to(login_url)
    end

    # it "ログインしていない状態でユーザーをフォロー解除するとログインURLにアクセスする" do
    #   expect {
    #     delete relationships_path
    #   }.to_not change(Relationship, :count)
    #   expect(response).to redirect_to(login_url)
    # end

    # it "ログインしていない状態でフォロー中のユーザー一覧ページにアクセスするとログインURLにリダイレクトされる" do
    #   get following_user_path(user)
    #   expect(response).to redirect_to(login_url)
    # end

    # it "ログインしていない状態でフォロワー一覧ページにアクセスするとログインURLにリダイレクトされる" do
    #   get followers_user_path(user)
    #   expect(response).to redirect_to(login_url)
    # end
  end
end

# 置き換える残りのファイル
# microposts_controller_test.rb
# users_controller_test
# relationships_controller_test.rb

require 'rails_helper'

