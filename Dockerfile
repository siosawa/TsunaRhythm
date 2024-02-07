FROM ruby:3.2.2
RUN mkdir /app
WORKDIR /app
COPY . /app
# CMD ["/bin/bash"]で確認した後記述
CMD ["sh", "-c", "bundle install && rails s -b 0.0.0.0"]
