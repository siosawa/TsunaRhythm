require 'rails_helper'
# ログインの有無によるマイクロポストのCRUD処理の検証
RSpec.describe 'Microposts' do
  describe 'ログイン確認テスト' do
    let(:user) { create(:user) }
    let(:unregistered_user) { build(:user) }

    context '存在するユーザーは' do
      specify 'ログインが成功しルートパスにリダイレクトする' do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
        expect(response).to redirect_to(root_url)
      end
    end

    context '存在しないユーザーは' do
      specify 'ログインが失敗しnewテンプレートがレンダーされる' do
        session_params = { email: unregistered_user.email, password: unregistered_user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost, user_id: user.id) }
    let(:other_user) { create(:user) }
    let(:other_micropost) { create(:micropost) }

    context 'ログインしている状態で' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
      end

      specify 'GET #post_pathへのリクエストが成功し、HTTPステータスコード200が返される' do
        get post_path(user)
        expect(response).to have_http_status(:ok)
      end

      specify 'ログインユーザーのマイクロポストが3件正確に表示される' do
        get post_path(user)
        user.microposts.limit(3).each do |micropost|
          expect(response.body).to include(micropost.content)
        end
      end

      specify 'マイクロポストの作成が成功すると、post数が3件増える' do
        expect do
          post microposts_path, params: { micropost: { content: 'テスト投稿' } }
          post microposts_path, params: { micropost: { content: 'テスト投稿' } }
          post microposts_path, params: { micropost: { content: 'テスト投稿' } }
        end.to change(user.microposts, :count).by(3)
      end

      specify 'マイクロポストの作成が失敗すると、post数が増減しない' do
        expect do
          post microposts_path, params: { micropost: { content: ' ' } }
        end.not_to change(user.microposts, :count)
      end
    end

    context 'ログインしていない状態で' do
      # 　未実装
      # specify 'GET #post_pathへのリクエストが失敗しlogin_pathにリダイレクトされる' do
      #   get post_path
      #   expect(response).to redirect_to(login_path)
      # end

      specify 'マイクロポストを作成しようとするとlogin_pathにリダイレクトされる' do
        post microposts_path, params: { micropost: { content: 'テスト投稿' } }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'ログインしている状態でフォローしているユーザーのマイクロポストの閲覧' do
    let(:user) { create(:user) }
    let(:alice_user) { create(:user) }
    let(:bob_user) { create(:user) }

    before do
      # ログイン
      session_params = { email: user.email, password: user.password, remember_me: 0 }
      post login_path, params: { session: session_params }
      # 別のユーザーでマイクロポストを新規作成
      @micropost1 = create(:micropost, user: alice_user)
      @micropost2 = create(:micropost, user: bob_user)
      # ログインユーザーで別のユーザーをフォロー
      post relationships_path, params: { followed_id: alice_user.id }
      post relationships_path, params: { followed_id: bob_user.id }
    end

    specify 'GET #post_pathへのリクエストが成功し、HTTPステータスコード200が返される' do
      get post_path(user)
      expect(response).to have_http_status(:ok)
    end

    specify '他のユーザーが投稿したマイクをポストが確認できる' do
      get post_path
      expect(response.body).to include(@micropost1.content)
      expect(response.body).to include(@micropost2.content)
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    # 未実装
    # context 'ログインしていない状態' do
    #   before do
    #   @micropost = create(:micropost, user: user)
    #   end
    #   specify 'ログイン画面へ遷移する' do
    #     expect {
    #       delete micropost_path(@micropost)
    #     }.to redirect_to(rogin_path)
    #   end
    # end

    context 'ログインしている状態' do
      before do
        # ログイン
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
        # 新規マイクロポスト作成
        @micropost = create(:micropost, user:)
      end

      specify 'マイクロポストの削除が成功すると、post数が1件減る' do
        expect do
          delete micropost_path(@micropost)
        end.to change(user.microposts, :count).by(-1)
      end

      specify 'マイクロポストの削除が失敗すると、post数が変わらない' do
        # 別のユーザーのマイクロポストを削除しようとする
        other_micropost = create(:micropost, user: other_user)
        expect do
          delete micropost_path(other_micropost)
        end.not_to change(other_user.microposts, :count)
      end
    end
  end
end
