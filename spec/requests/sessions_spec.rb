require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }
  let(:unregistered_user) { build(:user) }

  describe 'POST #create' do
    context '存在するユーザー' do
      specify 'ログインが成功するとルートパスにリダイレクトする' do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
        expect(response).to redirect_to(root_url) 
      end
    end

    context '存在しないユーザー' do
      specify 'ログインが失敗する' do
        session_params = { email: unregistered_user.email, password: unregistered_user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      post login_path, params: { session: { email: user.email, password: 'password' } }
      delete logout_path
    end

    it 'ログアウトが成功し、ルートURLにリダイレクトされる' do
      expect(response).to redirect_to(root_url)
    end

    it 'ログアウトによりセッションがクリアされていることを確認' do
      expect(session[:user_id]).to be_nil
    end

    it 'ステータスコードが303(See Other)であることを確認' do
      expect(response).to have_http_status(:see_other)
    end
  end

  # describe 'GET #check_session' do
  #   specify 'ログイン中のユーザー情報を返す' do
  #     # ログイン
  #     session_params = { email: user.email, password: user.password, remember_me: 0 }
  #     post login_path, params: { session: session_params }
  #     # リクエスト実行
  #     get '/api/v1/check'
  #     json = JSON.parse(response.body)

  #     expect(response).to have_http_status :ok
  #     expect(json['user']['name']).to eq(user.name)
  #   end
  # end
end