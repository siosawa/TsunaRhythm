# つなリズムアプリケーション

## 使い方

このアプリケーションをCodespacesから動かす場合
```
$ bundle install
```
```
$ rails s
```
アカウントに接続できない場合は以下も実行する。
```
$ rails db:seed
```

VSコード他ローカル環境からDockerを使って実行する場合は以下のコードから実行
```
$ docker image build -t tsunarhythm:latest .
```
```
$ docker container run -it -p 3000:3000 --name tsunarhythm -v "${PWD}:/app" tsunarhythm:latest
```
これでローカル環境の場合http://0.0.0.0:3000/ から確認できる。
アカウントに接続できない場合は以下も実行する。
```
$ rails db:seed
```
test