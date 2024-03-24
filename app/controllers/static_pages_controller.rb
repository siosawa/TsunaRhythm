class StaticPagesController < ApplicationController
  def help
    # 何も記入されていない時はapp/views/static_pages/help.html.erbを表示
  end

  def about; end

  def post
    return unless logged_in?

    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page])
  end
end
