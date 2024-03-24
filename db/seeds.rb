# # メインのサンプルユーザーを1人作成する
User.find_or_create_by(email: 'example@railstutorial.org') do |user|
  user.name = 'Example User'
  user.password = 'foobar'
  user.password_confirmation = 'foobar'
  user.admin = true
  user.activated = true
  user.activated_at = Time.zone.now
end

# 追加のユーザーをまとめて生成する
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.find_or_create_by(email:) do |user|
    user.name = name
    user.password = password
    user.password_confirmation = password
    user.activated = true
    user.activated_at = Time.zone.now
  end
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content:) }
end

# ユーザーフォローのリレーションシップを作成する
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) unless user.following?(followed) }
followers.each { |follower| follower.follow(user) unless follower.following?(user) }
