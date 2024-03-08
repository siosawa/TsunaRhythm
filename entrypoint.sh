#!/bin/bash
set -e

# server.pidが残っている場合は削除
rm -f /tmp/pids/server.pid

# データベースのセットアップ
bundle exec rails assets:precompile # いろんなファイルを一緒に実行
bundle exec rails assets:clean # assetsの使わないものを無効化
bundle exec rails db:create --trace
bundle exec rails db:migrate --trace
bundle exec rails db:seed --trace

# コマンドライン引数で指定されたコマンドを実行
exec "$@"


