require 'rails_helper'

RSpec.describe 'Sessions' do
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

    specify 'ログアウトが成功し、ルートURLにリダイレクトされる' do
      expect(response).to redirect_to(root_url)
    end

    specify 'ログアウトによりセッションがクリアされていることを確認' do
      expect(session[:user_id]).to be_nil
    end

    specify 'ステータスコードが303(See Other)であることを確認' do
      expect(response).to have_http_status(:see_other)
    end
  end
end
