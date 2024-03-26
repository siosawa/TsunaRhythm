class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  # ユーザーのログインを確認する
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = I18n.t('sessions.flash.danger')
    redirect_to login_url, status: :see_other
  end
end
