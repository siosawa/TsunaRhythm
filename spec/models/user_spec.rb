require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:other_user) { create(:user) } # ユーザー削除テストもするのでcreateを使う

  describe 'validation' do
    specify 'name,email,passwordがある場合、有効である' do
      expect(user).to be_valid
    end

    describe 'name' do
      specify '存在しない場合、無効である' do
        user.name = ''
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end

      specify '51文字以上の場合、無効である' do
        user.name = 'a' * 51
        user.valid?
        expect(user.errors[:name]).to include('は50文字以内で入力してください')
      end
    end

    describe 'email' do
      specify '存在しない場合、無効である' do
        user.email = ''
        user.valid?
        expect(user.errors[:email]).to include('を入力してください')
      end
    end

    specify '256文字以上の場合、無効である' do
      user.email = 'a' * 256
      user.valid?
      expect(user.errors[:email]).to include('は255文字以内で入力してください')
    end

    specify '異常な形式である場合、無効である' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        user.valid?
        expect(user.errors[:email]).to include('は不正な値です')
      end
    end

    specify '重複する場合、無効である' do
      user.save
      duplicate_user = build(:user, email: user.email.upcase)
      duplicate_user.valid?
      expect(duplicate_user.errors[:email]).to include('はすでに存在します')
    end
  end

  describe 'password' do
    specify '存在しない場合、無効である' do
      user.password = user.password_confirmation = ' ' * 6
      user.valid?
      expect(user.errors[:password]).to include('を入力してください')
    end

    specify '5文字以下の場合、無効である' do
      user.password = user.password_confirmation = 'a' * 5
      user.valid?
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end

    specify '暗号化されていない場合、無効である' do
      user.save
      expect(user.password_digest).not_to eq 'password'
    end

    specify 'password_confirmationと一致しない場合、無効である' do
      user.password = 'password'
      user.password_confirmation = 'foobar'
      expect(user).not_to be_valid
    end
  end
  describe 'association' do
    describe 'micropost' do
      specify 'userが削除された時、関連するマイクロポストも削除される' do
        user.save
        user.microposts.create!(content: 'テストポスト')
        expect { user.destroy }.to change(Micropost.all, :count).by(-1)
      end
    end
  end

  describe 'active_relationships' do
    specify 'userが削除された時、関連するactive_relationshipsも削除される' do
      user.save
      user.follow(other_user)
      expect { user.destroy }.to change(Relationship.all, :count).by(-1)
    end
  end

  describe 'passive_relationships' do
    specify 'userが削除された時、関連するpassive_relationshipsも削除される' do
      user.save
      other_user.follow(user)
      expect { user.destroy }.to change(Relationship.all, :count).by(-1)
    end
  end
end
