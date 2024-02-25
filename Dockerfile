FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y nodejs default-libmysqlclient-dev
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
CMD ["/bin/bash"]

# docker system prune -a
# docker image build -t tsunarhythm:v1 .
# docker container run -it -p 3000:3000 --name tsunarhythm -v "${PWD}:/app" tsunarhythm:v1
# rails db:seed
# rails s -d -b 0.0.0.0
# http://0.0.0.0:3000/ へアクセス

# docker-compose build
# docker-compose up
