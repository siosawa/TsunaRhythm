require 'rails_helper'

RSpec.describe RelationshipsController, type: :request do
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
    let(:other_user) { create(:user) } 

    context 'ログインしていない状態で' do
      it 'フォローするとログイン画面にリダイレクトする' do
        post relationships_path, params: { followed_id: other_user.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'ログインしている状態で' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
      end

      it "フォローするとRelationshipの数が1増える" do
        expect {
        post relationships_path, params: { followed_id: other_user.id }
        }.to change(Relationship, :count).by(1)
      end

      # すでにフォローしているユーザーをフォローするとエラーになる
    end
    
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    
    context 'ログインしていない状態で' do
      before do
        @relationship = user.active_relationships.create(followed_id: other_user.id)
      end

      it 'フォロー解除するとRelationshipの数が変わらない' do
        expect {
          delete relationship_path(@relationship)
        }.to_not change(Relationship, :count)
        expect(response).to redirect_to(login_path)  
      end
      
      it 'フォロー解除すると失敗し、ログイン画面にリダイレクトする' do
        delete relationship_path(@relationship)
        expect(response).to redirect_to(login_path)
      end
    end

    context 'ログインしている かつ other_userをフォローしている状態で' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
        @relationship = user.active_relationships.create(followed_id: other_user.id)
      end

      it 'フォロー解除をするとRelationshipの数が1減少する' do
        expect {
          delete relationship_path(@relationship)
        }.to change(Relationship, :count).by(-1)
      end
    end  
  end
end
