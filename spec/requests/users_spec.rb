require 'rails_helper'

# RSpec/FilePath規定に引っかかるのでクラス名をUsersControllerから"<request>Users"に変更
RSpec.describe '<request>Users' do
  let(:user) { create(:user) }

  describe 'ログイン確認テスト' do
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

  describe 'GET #index' do
    context 'ログインしているユーザーの場合' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
      end

      specify 'リクエストが成功すること' do
        get users_path
        expect(response).to have_http_status(:ok)
      end

      specify 'ユーザー一覧が取得できること' do
        get users_path
        expect(assigns(:users)).not_to be_empty
      end
    end

    context 'ログインしていない場合' do
      specify 'ログインページにリダイレクトすること' do
        get users_path
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe 'GET #show' do
    specify 'リクエストが成功すること' do
      get user_path(user)
      expect(response).to have_http_status(:ok)
    end

    specify '指定したユーザーが取得できること' do
      get user_path(user)
      expect(assigns(:user)).to eq user
    end

    specify 'マイクロポストが取得できること' do
      get user_path(user)
      expect(assigns(:microposts)).to match_array(user.microposts)
    end
  end

  describe 'POST #create' do
    context '成功の場合' do
      specify 'ユーザー数が1件増える' do
        expect do
          post users_path, params: { user: {
            name: 'Alice',
            email: 'example@gmail.com',
            password: 'password',
            activated: true
          } }
        end.to change(User, :count).by(1)
      end

      specify 'ルートURLにリダイレクトすること' do
        post users_path, params: { user: {
          name: 'Bob',
          email: 'example@gmail.com',
          password: 'password',
          activated: true
        } }
        expect(response).to redirect_to(root_url)
      end
    end

    context '失敗の場合' do
      specify 'ユーザー数が増減しない' do
        expect do
          post users_path, params: { user: {
            name: 'Alice',
            email: 'example@gmail.com',
            password: '',
            activated: true
          } }
        end.not_to change(User, :count)
      end

      specify '新規登録ページが再表示されること' do
        post users_path, params: { user: {
          name: 'Bob',
          email: 'example@gmail.com',
          password: '',
          activated: true
        } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    context 'ログインしているユーザーの場合' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
      end

      context '有効な属性値の場合' do
        let(:user_params) { { name: 'Updated Name', email: 'updated@example.com' } }

        before do
          patch user_path(user), params: { user: user_params }
          user.reload
        end

        specify 'ユーザーの名前が更新されること' do
          expect(user.name).to eq('Updated Name')
        end

        specify 'ユーザーのメールアドレスが更新されること' do
          expect(user.email).to eq('updated@example.com')
        end

        specify 'ユーザーのプロフィールページにリダイレクトすること' do
          expect(response).to redirect_to(user)
        end
      end

      context '無効な属性値の場合' do
        specify 'ユーザー情報を更新できず、編集ページが再表示されること' do
          patch user_path(user), params: { user: { name: '', email: 'foo@invalid' } }
          expect(response).to render_template('edit')
        end
      end

      context 'ログインユーザー以外を更新しようとする場合' do
        let(:other_user) { create(:user) }
        let(:other_user_params) { { name: 'Updated Name', email: 'updated@example.com' } }

        specify '編集ページにはリダイレクトされない' do
          patch user_path(other_user), params: { user: other_user_params }
          expect(response).not_to render_template('edit')
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context 'ログインしていない場合' do
      specify 'ログインページにリダイレクトすること' do
        patch user_path(user), params: { user: { name: 'Foo', email: 'foo@bar.com' } }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:admin_user) { create(:user, :admin) }
    let!(:deletable_user) { create(:user) }
    let!(:redirect_check_user) { create(:user) }
    let!(:non_admin_delete_attempt_user) { create(:user) }

    context '管理者ユーザーとしてログインしている場合' do
      before do
        session_params = { email: admin_user.email, password: admin_user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
      end

      specify 'ユーザーを削除できること' do
        expect do
          delete user_path(deletable_user)
        end.to change(User, :count).by(-1)
      end

      specify 'ユーザー一覧ページにリダイレクトすること' do
        delete user_path(redirect_check_user)
        expect(response).to redirect_to(users_url)
      end
    end

    context '非管理者ユーザーとしてログインしている場合' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
      end

      specify 'ユーザーを削除できず、ホームページにリダイレクトすること' do
        delete user_path(non_admin_delete_attempt_user)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET #following' do
    let(:other_user) { create(:user) }

    context 'ログインしているユーザーの場合' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
      end

      specify 'リクエストが成功すること' do
        get following_user_path(user)
        expect(response).to have_http_status(:ok)
      end

      specify 'フォローしているユーザーの一覧が取得できること' do
        user.follow(other_user)
        get following_user_path(user)
        expect(response.body).to include(other_user.name)
      end
    end

    context 'ログインしていない場合' do
      specify 'ログインページにリダイレクトすること' do
        get following_user_path(user)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'GET #followers' do
    context 'ログインしているユーザーの場合' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
      end

      specify 'リクエストが成功すること' do
        get followers_user_path(user)
        expect(response).to have_http_status(:ok)
      end

      specify 'フォロワーの一覧が取得できること' do
        get followers_user_path(user)
        expect(assigns(:users)).to match_array(user.followers)
      end
    end

    context 'ログインしていない場合' do
      specify 'ログインページにリダイレクトすること' do
        get followers_user_path(user)
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
