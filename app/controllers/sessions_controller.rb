class SessionsController < ApplicationController

  # 新しいセッション（ログインフォーム）を表示するアクションです。
  def new
  end

  # ログイン処理を行うアクションです。
  def create
    # ユーザーをメールアドレスで検索します。入力されたメールアドレスは小文字に変換されます。
    user = User.find_by(email: params[:session][:email].downcase)
    # ユーザーが存在し、かつパスワードが正しい場合にログイン処理を続行します。
    if user && user.authenticate(params[:session][:password])
      # ユーザーがアクティベーションされているかをチェックします。
      if user.activated?
        # ログイン後にリダイレクトするURLをセッションから取得します。
        forwarding_url = session[:forwarding_url]
        # セッションをリセットします。
        reset_session
        # ユーザーのログイン情報を記憶するかどうかを、フォームからの入力に基づいて判定します。
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # ユーザーをログイン状態にします。
        log_in user
        # ルートURLまたは指定されたURLにリダイレクトします。
        redirect_to root_url || user
      else
        # アカウントがアクティベーションされていない場合のメッセージを設定します。
        message  = "アカウントがアクティブ化されていません"
        message += "メールでアクティベーションリンクを確認してください"
        flash[:warning] = message
        # ルートURLにリダイレクトします。
        redirect_to root_url
      end
    else
      # メールアドレスとパスワードの組み合わせが無効な場合、エラーメッセージを表示します。
      flash.now[:danger] = 'メールアドレスとパスワードの組み合わせが無効です'
      # ログインフォームを再度表示します。
      render 'new', status: :unprocessable_entity
    end
  end

  # ログアウト処理を行うアクションです。
  def destroy
    # ユーザーがログインしている場合、ログアウトします。
    log_out if logged_in?
    # ルートURLにリダイレクトし、ステータスコード303(See Other)を返します。
    redirect_to root_url, status: :see_other
  end
end
