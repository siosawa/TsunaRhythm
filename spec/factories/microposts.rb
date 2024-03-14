FactoryBot.define do
    factory :content do
      # 英数字のランダムな文字列を生成する（100文字）
      content { Faker::Lorem.characters(number: 100) }
      # 上記の記述によりbuild(:content)でテストデータを生成できる
    end
  end