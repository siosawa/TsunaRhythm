class AccountActivationsController < ApplicationController
  # "#{認証名}_digest"や#{認証名}_tokenを使う
  def edit
    user = User.find_by(email: params[:email])
    # Eメールからユーザーを探す。
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # userはnilではないよね？認証はされてないですよね？じゃアクティベーションとID（トークン）で認証をするよ
      user.activate
      # user.update_attribute(:activated,    true)
      # user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = 'Account activated!'
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end
