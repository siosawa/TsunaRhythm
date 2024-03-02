#!/bin/bash
set -e

# server.pidが残っている場合は削除
rm -f /tmp/pids/server.pid

# コマンドライン引数で指定されたコマンドを実行
exec "$@"


