# 実際にユーザーに送られる文面のチェックができる。
# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at https://fantastic-system-6q75jx75xjg2rp59-3000.app.github.dev/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

   # Preview this email at
  # https://fantastic-system-6q75jx75xjg2rp59-3000.app.github.dev/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

end



