require 'rails_helper'

RSpec.describe Micropost do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost) }

  describe 'テストデータ' do
    specify 'のuser_id, contentがある場合は有効になる' do
      expect(micropost).to be_valid
    end

    specify 'user_idが存在しない場合は無効になる' do
      micropost.user_id = nil
      expect(micropost).not_to be_valid
    end

    specify 'のcontentが空の時は無効になる' do
      micropost.content = ''
      expect(micropost).not_to be_valid
    end

    specify 'のcontentが140字を超えた時は無効になる' do
      micropost.content = Faker::Lorem.characters(number: 141)
      expect(micropost).not_to be_valid
    end
  end
end
