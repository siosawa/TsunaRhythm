# 何も書かれていなければ最後のコードが戻り値としてレンダー（実行される）
class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy
                                          following followers]
  before_action :correct_user,   only: %i[edit update]
  before_action :admin_user,     only: :destroy
  # ログインしている前提の処理なので、ログインしているかどうかを見てからcorrect_user
  # をおこなっている。
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    Rails.logger.info 'users_controllerのshowアクションを実行しようとしています'
    # @user = User.first
    @user = User.find(params[:id])
    # アクセスしたパラムズのURLの値をidとしてUserデータベースからアクセスする。
    @microposts = @user.microposts.paginate(page: params[:page])
    Rails.logger.info 'users_controllerのshowアクションが完了しました'
  end

  def new
    # => GET app/views/users/new.html.erb
    Rails.logger.info 'users_controllerのnewアクションを実行しようとしています'
    @user = User.new
    Rails.logger.info 'users_controllerのnewアクションが完了しました'
  end

  def edit
    Rails.logger.info 'users_controllerのeditアクションを実行しようとしています'
    @user = User.find(params[:id])
    Rails.logger.info 'users_controllerのeditアクションが完了しました'
  end

  def create
    Rails.logger.info 'ユーザー作成処理を開始します。'
    @user = User.new(user_params)
    if @user.save
      Rails.logger.info "ユーザー(ID: #{@user.id})が正常に保存されました。アクティベーションメールを送信します。"
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      Rails.logger.warn 'ユーザーの保存に失敗しました。ユーザー作成フォームを再表示します。'
      render 'new', status: :unprocessable_entity
    end
    Rails.logger.info 'ユーザー作成処理が完了しました。'
  end

  def update
    Rails.logger.info 'users_controllerのupdateアクションを実行しようとしています'
    @user = User.find(params[:id])
    if @user.update(user_params)
      Rails.logger.info 'ユーザー情報の更新に成功しました。'
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      Rails.logger.info 'ユーザー情報の更新に失敗しました。'
      render 'edit', status: :unprocessable_entity
    end
  end

  # def destroy
  #   Rails.logger.info "users_controllerのdestroyアクションを実行しようとしています"
  #   User.find(params[:id]).destroy
  #   Rails.logger.info "ユーザーを削除しました。"
  #   flash[:success] = "ユーザーを削除しました"
  #   redirect_to users_url, status: :see_other
  # end

  def destroy
    Rails.logger.info 'users_controllerのdestroyアクションを実行しようとしています'
    user = User.find_by(id: params[:id])

    if user.nil?
      Rails.logger.info 'ユーザーが見つかりませんでした。'
      flash[:alert] = 'User not found.'
      redirect_to users_url and return
    end

    if user.destroy
      Rails.logger.info 'ユーザーを削除しました。'
      flash[:success] = t('users.destroy.flash.success')
    else
      Rails.logger.info 'ユーザーの削除に失敗しました。'
      flash[:alert] = t('users.destroy.flash.danger')
    end

    redirect_to users_url, status: :see_other
  end

  def following
    Rails.logger.info 'users_controllerのfollowingアクションを実行しようとしています'
    @title = 'Following'
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    Rails.logger.info 'フォローしているユーザーの表示に成功しました。'
    render 'show_follow'
  end

  def followers
    Rails.logger.info "#{params[:id]}番のユーザーのfollowersアクションを実行しようとしています"
    @title = 'Followers'
    @user  = User.find(params[:id])
    Rails.logger.info "#{@user.name}のフォロワーを取得しています。"
    @users = @user.followers.paginate(page: params[:page])
    Rails.logger.info "#{@user.name}のフォロワー表示処理が完了しました。"
    render 'show_follow'
  end

  private # これはなくても良いミニミニヘルパーみたいなもの。users controrerの中で使う

  # メソッドにするコマンド。継承した場合は普通に使える。メソッド名が同じでも使えるようにしている
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

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
