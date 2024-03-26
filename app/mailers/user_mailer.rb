class UserMailer < ApplicationMailer
  # アカウント有効化メール
  def account_activation(user)
    @user = user
    mail to: user.email, subject: t('Account.activation')
  end

  # パスワードリセットメール
  def password_reset(user)
    @user = user
    mail to: user.email, subject: t('password.reset')
  end
end
