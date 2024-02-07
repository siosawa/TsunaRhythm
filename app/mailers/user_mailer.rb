# class UserMailer < ApplicationMailer

#   def account_activation(user)
#     @user = user # テキストで呼び出せる
#     mail to:user.email, 
#     subject: "Account activation"
#   end

#   def password_reset
#     @greeting = "Hi"

#     mail to: "to@example.org"
#   end
# end
class UserMailer < ApplicationMailer

  # アカウント有効化メール
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # パスワードリセットメール
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
