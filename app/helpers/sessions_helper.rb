module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    # セッションリプレイ攻撃から保護する
    # 詳しくは https://bit.ly/33UvK0w を参照
    session[:session_token] = user.session_token
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember(user) # 引数が必ず必要な方のrememberメソッド
    user.remember 
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    # メソッドが終わったらデータを忘れる。
  end
  
  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      @current_user ||= user if user && session[:session_token] == user.session_token
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
 #  # 記憶トークンのcookieに対応するユーザーを返す
 #  def current_user
 #   if (user_id = session[:user_id])
 #     user = User.find_by(id: user_id)
 #     if user && session[:session_token] == user.session_token
 #       @current_user = user
 #     end 
 #   elsif (user_id = cookies.encrypted[:user_id])
 #     user = User.find_by(id: user_id)
 #     # if user && user.authenticated?(cookies[:remember_token])
 #     if user && user.authenticated?(:remember, cookies[:remember_token])
 #      log_in user
 #       @current_user = user
 #     end
 #   end
 # end

 # 渡されたユーザーがカレントユーザーであればtrueを返す  
  def current_user?(user)
    user && user == current_user
  end


  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # # 現在のユーザーをログアウトする
  # def log_out
  #   reset_session
  #   @current_user = nil   # 安全のため
  # end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget # リメンバーダイジェストの削除
    cookies.delete(:user_id) # クッキーデータ削除
    cookies.delete(:remember_token) # リメンバートークン削除 
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user) # userのクッキー内のデータを削除
    reset_session
    @current_user = nil
  end
  
  # アクセスしようとしたURLを保存する
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
