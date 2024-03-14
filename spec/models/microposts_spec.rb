require 'rails_helper'

RSpec.describe Micropost, type: :model do
    # letは遅延評価といい定義した定数が初めて出てきた時に評価される
    let(:micropost) { build(:micropost) }
    it "のコンテントが有効の時" do
      expect(micropost).to be_valid
    end
    it "のコンテントが空で無効の時" do
      micropost.content = ''
      expect(micropost).to_not be_valid
    end
    it "のコンテントが140字を超えて無効の時" do
      micropost.content = Faker::Lorem.characters(number: 141)
      expect(micropost).to_not be_valid
    end
  end
