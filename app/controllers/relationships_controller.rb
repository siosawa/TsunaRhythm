class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    Rails.logger.info "RelationshipsControllerのcreateアクションが実行されようとしています。"
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    Rails.logger.info "ユーザー(ID: #{current_user.id})がユーザー(ID: #{@user.id})をフォローしました。"
    respond_to do |format|
      format.html { redirect_to @user }
      format.turbo_stream
    end
  end

  def destroy
    Rails.logger.info "RelationshipsControllerのdestroyアクションが実行されようとしています。"
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    Rails.logger.info "ユーザー(ID: #{current_user.id})がユーザー(ID: #{@user.id})をフォロー解除しました。"
    respond_to do |format|
      format.html { redirect_to @user, status: :see_other }
      format.turbo_stream
    end
  end
end
