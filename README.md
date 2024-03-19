# dockerコマンドによる起動手順
```
docker system prune -a
```
```
docker build -t tsunarhythm:v1 .
```
```
docker network create my_app_network
```
```
docker run -d --name db --network my_app_network -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 mysql:8.0.36
```
```
docker run -d --name web --network my_app_network -p 3000:3000 -v $(pwd):/app tsunarhythm:v1 bundle exec rails s -p 3000 -b '0.0.0.0'
```
http://0.0.0.0:3000/ へアクセス または http://localhost:3000/ へアクセス

# docker停止手順
```
docker ps でコンテナIDを確認
```
```
docker stop webID でコンテナを停止
```
```
docker stop MySQLID でMySQLを停止
```
```
docker system prune -a でイメージとコンテナを削除
```

# docker-composeコマンドによる起動手順
```
docker-compose build
```
```
docker-compose up -d
```
http://localhost:3000/ へアクセス
```
docker-compose down
```

# ECRへのpush手順
```
docker build --platform linux/amd64 -t ************.dkr.ecr.ap-northeast-1.amazonaws.com/tsunarhythm:v1 . 
```
```
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ************.dkr.ecr.ap-northeast-1.amazonaws.com
```
```
docker push ************.dkr.ecr.ap-northeast-1.amazonaws.com/tsunarhythm:v1
```

# テストの実行
```
bundle exec rspec
```
### テストの実行で中身も確認
```
bundle exec rspec --format documentation
```
### テスト環境毎のDBのマイグレーション
```
rails db:migrate RAILS_ENV=test
```
# ブランチを作成しつつ切り替え
```
git switch -c add_test
```
### ブランチを切り替え
```
git switch add_test
```
# わかりやすいコミットメッセージの書き方の例
1. 追加: ユーザー新規登録機

2. 修正: 何を修正したか

3. リファクタリング: 何をリファクタリングしたか

4. テスト: 何をテストしたか

5. その他: その他

# gitリポジトリとの紐付けを削除しつつローカルファイルを残す
※ gitignoreファイルへのファイルパス、ディレクトリパスの追加を忘れずに。
```
git rm --cached ファイルパス
```
```
git rm --cached -r  ディレクトリパス/
```