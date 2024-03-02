#!/bin/bash
set -e

# server.pidが残っている場合は削除
rm -f /tmp/pids/server.pid

# データベースのセットアップ
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

# コマンドライン引数で指定されたコマンドを実行
exec "$@"


