class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    Rails.logger.info "microposts_controllerのcreateアクションが実行されようとしています。"
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to post_path
      Rails.logger.info "マイクロポストが作成されました。ユーザーID: #{current_user.id}, マイクロポスト内容: #{@micropost.content}"
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/post', status: :unprocessable_entity
      Rails.logger.info "マイクロポストの保存に失敗しました。ユーザーID: #{current_user.id}"
    end
  end

  def destroy
    micropost_content = @micropost.content 
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    Rails.logger.info "マイクロポストが削除されました。ユーザーID: #{current_user.id}, 削除されたマイクロポストの内容: #{micropost_content}"
    if request.referrer.nil?
      Rails.logger.info "リファラーが存在しないため、ルートURLにリダイレクトします。ユーザーID: #{current_user.id}, 削除されたマイクロポストの内容: #{micropost_content}"
      redirect_to root_url, status: :see_other
    else
      Rails.logger.info "前のページ（リファラー: #{request.referrer}）にリダイレクトします。ユーザーID: #{current_user.id}, 削除されたマイクロポストの内容: #{micropost_content}"
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @micropost.nil?
      Rails.logger.info "マイクロポストが見つかりません。ユーザーID: #{current_user.id}, 指定されたID: #{params[:id]}"
    end
end
