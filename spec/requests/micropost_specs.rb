require 'rails_helper'
# ログインの有無によるマイクロポストのCRUD処理の検証
RSpec.describe 'Microposts', type: :request do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user_id: user.id)}
  let(:other_user) { create(:user) }
  let(:other_micropost) { create(:micropost) }

  describe 'GET #index' do
    before do
      @micropost1 = create(:micropost)
      @micropost2 = create(:micropost)
    end

    specify 'リクエストが成功する' do
      get microposts_path
      expect(response).to have_http_status :ok
    end
  end
end

