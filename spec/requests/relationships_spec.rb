require 'rails_helper'

RSpec.describe RelationshipsController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:target_user) { create(:user) }
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

  describe 'POST #create' do
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

      it "ユーザーをフォローするとRelationshipの数が1増える" do
        expect {
        post relationships_path, params: { followed_id: other_user.id }
        }.to change(Relationship, :count).by(1)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログインしていない状態で' do
      it 'フォロー解除しようとするとログイン画面にリダイレクトされる' do
        relationship = Relationship.new(follower_id: user.id, followed_id: target_user.id)
        relationship.save
        expect {
          delete relationship_path(relationship)
        }.not_to change(Relationship, :count)
        expect(response).to redirect_to(login_path)
      end
    end


    context 'ログインしている状態で' do
      before do
        session_params = { email: user.email, password: user.password, remember_me: 0 }
        post login_path, params: { session: session_params }
        post relationships_path, params: { followed_id: target_user.id }
        @relationship = user.active_relationships.create(followed_id: target_user.id)
      end

      it 'フォロー解除をするとRelationshipの数が1減少する' do
        expect {
          delete relationship_path(@relationship)
        }.to change(Relationship, :count).by(-1)
      end

      #フォローしていないユーザーのフォローを解除しようとすると操作失敗の情報を返す
    end  
  end
end
