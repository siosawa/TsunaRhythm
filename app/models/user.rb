class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy,
                                  inverse_of: :follower

  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy,
                                   inverse_of: :followed

  has_many :following, through: :active_relationships, source: :followed

  has_many :followers, through: :passive_relationships, source: :follower

  # データベースと連携しない、インスタンス変数とほぼ同義のremember_tokenを作成する
  # メソッドを作るメソッド（メタメソッド）を作成する
  attr_accessor :remember_token, :activation_token, :reset_token

  # アカウントを追加する直前に行う。渡したメールアドレスを小文字にしたものをセーブする直前に自分自身にコピーする
  # 大文字と小文字で複数メールアドレスを登録できないようにする。大抵のデータベースでは必要ない。
  before_save   :downcase_email

  # 前提を作り上げる
  before_create :create_activation_digest # からのインスタンスがデータに保存された時。バリデーションを通過したとき。
  validates :name,  presence: true, length: { maximum: 50 }

  # nameに空白スペースがあるかを検証する。空白スペースがなければtrue
  validates :email, presence: true, length: { maximum: 255 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # 大文字は定数（動的に変更されることのない値）として扱われる。
  validates :email, presence: true, length:     { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } # 大文字小文字は無視
  has_secure_password # セキュアなパスワード機能を導入。ハッシュ値のログだって見せないよ。
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す(記憶ダイジェストを再利用しているのは単に利便性のため)
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send(:"#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
             .includes(:user, image_attachment: :blob)
  end

  # ユーザーをフォローする
  def follow(other_user)
    Rails.logger.info "ユーザー(ID: #{id})がユーザー(ID: #{other_user.id})をフォローしようとしています。"
    following << other_user unless self == other_user
    Rails.logger.info "ユーザー(ID: #{id})がユーザー(ID: #{other_user.id})をフォローしました。"
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    Rails.logger.info "ユーザー(ID: #{id})がユーザー(ID: #{other_user.id})をフォロー解除しようとしています。"
    following.delete(other_user)
    Rails.logger.info "ユーザー(ID: #{id})がユーザー(ID: #{other_user.id})をフォロー解除しました。"
  end

  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
