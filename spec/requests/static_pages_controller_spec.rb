require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "ルートURLにアクセスが成功する" do
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

    it "ログインしていない状態でユーザーをフォローするとログインURLにアクセスする" do
      expect {
        post relationships_path
      }.to_not change(Relationship, :count)
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