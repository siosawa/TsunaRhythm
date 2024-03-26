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
      flash[:success] = I18n.t('account_activations.edit.success')
      redirect_to user
    else
      flash[:danger] = I18n.t('account_activations.edit.danger')
      redirect_to root_url
    end
  end
end
