#!/usr/bin/env bash
# 上記はマジックコメントと呼ばれコンピュータが読み込む
# exit on error
set -o errexit # 下記のコードでエラーが起きた時、一旦処理を中断させるコード
bundle install # 各種ライブラリをインストール（railsとか）
bundle exec rails assets:precompile # いろんなファイルを一緒に実行
bundle exec rails assets:clean # assetsの使わないものを無効化
# bundle exec rails db:migrate:reset # 全てのデータベースをリセット
# bundle exec rails db:seed #seedデータをデータベースに加える
bundle exec rails db:migrate