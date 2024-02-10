# 何も書かれていなければ最後のコードが戻り値としてレンダー（実行される）
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                                  :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  # ログインしている前提の処理なので、ログインしているかどうかを見てからcorrect_user 
  # をおこなっている。
  def index
    @users = User.paginate(page: params[:page])  
  end

  def show
    # @user = User.first
    @user = User.find(params[:id])
    # アクセスしたパラムズのURLの値をidとしてUserデータベースからアクセスする。
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    # => GET app/views/users/new.html.erb
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # reset_session # セキュリティ対策
      # log_in @user # アカウント登録時にログインもする
      # # 保存の成功をここで扱う。
      # flash[:success] = "Welcome to the Sample App!"
      # # 変数かのように扱うメソッド。get リクエストされた時に1度だけ採用する。
      # # showでも良いが、後々のことを考えてflashを使う。
      # redirect_to @user #新しくHTTPリクエストを発行する。この場合はshowから
      # # @userオブジェクトを探し、そのidを自動で取得してredirectしてくれる
    else
      render 'new', status: :unprocessable_entity 
      #422エラーをユーザーに伝える。ブラウザでもエラーを確認できるようにする？
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  
  private #これはなくても良い。ミニミニヘルパーみたいなもの。users controrerの中で使う
  # メソッドにするコマンド。継承した場合は普通に使える。メソッド名が同じになっても大丈夫にしている
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    # beforeフィルタ

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end

