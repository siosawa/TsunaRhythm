require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost) }
  
  describe 'バリデーション' do
    specify 'のuser_id, contentがある場合有効' do
      expect(micropost).to be_valid
    end 

    it "のコンテントが有効" do
      expect(micropost).to be_valid
    end

    it "のコンテントが空の時は無効" do
      micropost.content = ''
      expect(micropost).to_not be_valid
    end

    it "のコンテントが140字を超えた時は無効" do
      micropost.content = Faker::Lorem.characters(number: 141)
      expect(micropost).to_not be_valid
    end
  end
end
