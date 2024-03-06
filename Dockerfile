FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y nodejs default-libmysqlclient-dev
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]

# dockerコマンドによる起動手順
# docker system prune -a
# docker build -t tsunarhythm:v1 .
# docker network create my_app_network
# docker run -d --name db --network my_app_network -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 mysql:8.0.36
# docker run -d --name web --network my_app_network -p 3000:3000 -v $(pwd):/app tsunarhythm:v1 bundle exec rails s -p 3000 -b '0.0.0.0'
# http://0.0.0.0:3000/ へアクセス

# docker停止手順
# docker ps でコンテナIDを確認
# docker stop webID でコンテナを停止
# docker stop MySQLID でMySQLを停止

# docker-composeコマンドによる起動手順
# docker-compose build
# docker-compose up -d
# docker-compose down

# ECRへのpush手順
# docker build --platform linux/amd64 -t 504252798833.dkr.ecr.ap-northeast-1.amazonaws.com/tsunarhythm:v1 . 
# aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 504252798833.dkr.ecr.ap-northeast-1.amazonaws.com
# docker push 504252798833.dkr.ecr.ap-northeast-1.amazonaws.com/tsunarhythm:v1