class PasswordResetsController < ApplicationController
  before_action :user_get,         only: %i[edit update]
  before_action :valid_user,       only: %i[edit update]
  before_action :check_expiration, only: %i[edit update] # （1）への対応

  def new; end

  def edit; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t('password_resets.create.flash.success')
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t('password_resets.create.flash.danger')
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, I18n.t('password_resets.update.empty_password'))
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      reset_session
      log_in @user
      flash[:success] = I18n.t('password_resets.update.flash.success')
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # beforeフィルタ

  def user_get
    @user = User.find_by(email: params[:email])
  end

  # 有効なユーザーかどうか確認する
  def valid_user
    unless @user&.activated? &&
           @user&.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  # トークンが期限切れかどうか確認する
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = I18n.t('password_resets.check_expriration.flash.disabled')
    redirect_to new_password_reset_url
  end
end
