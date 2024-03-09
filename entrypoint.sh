#!/bin/bash
# 上記はマジックコメントと呼ばれコンピュータが読み込む
# set -e はエラーが起きた時、一旦処理を中断させるコード
set -e

# server.pidが残っていると新たにサーバが起動できないエラーになるため削除
rm -f /tmp/pids/server.pid

# アセットプリコンパイルエラー対策。CSSやJSなどのアセットファイルをデプロイする時は事前にコンパイルする必要がある。この説明はRailsチュートリアルでもある。
bundle exec rails assets:precompile # いろんなファイルを一緒に実行
bundle exec rails assets:clean # assetsの使わないものを無効化

#　データベースの作成、マイグレーション、シードデータの投入
bundle exec rails db:create --trace
bundle exec rails db:migrate --trace
bundle exec rails db:seed --trace

# コマンドライン引数で指定されたコマンドを実行
exec "$@"


