class UserMailer < ApplicationMailer
  # アカウント有効化メール
  def account_activation(user)
    @user = user
    mail to: user.email, subject: I18n.t('mailers.user_mailer.account_activation.subject')
  end

  # パスワードリセットメール
  def password_reset(user)
    @user = user
    mail to: user.email, subject: I18n.t('mailers.user_mailer.password_reset.subject')
  end
end
