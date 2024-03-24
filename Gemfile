source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'active_storage_validations', '0.9.8'
gem 'bcrypt', '3.1.18'
gem 'bootsnap', '1.16.0', require: false
gem 'bootstrap-sass', '3.4.1'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'faker', '2.21.0'
gem 'image_processing', '1.12.2'
gem 'importmap-rails', '1.1.5'
gem 'jbuilder',        '2.11.5'
gem 'puma',            '5.6.5'
gem 'rails', '7.0.4.3'
gem 'sassc-rails',     '2.1.2'
gem 'sprockets-rails', '3.4.2'
gem 'stimulus-rails',  '1.2.1'
gem 'turbo-rails',     '1.4.0'
gem 'will_paginate', '3.3.1'
# gem "sqlite3",       "1.6.1"
gem 'mysql2', '~> 0.5.6'

group :production do
  gem 'aws-sdk-s3', '1.114.0', require: false
end

group :development, :test do
  gem 'debug', '1.7.1', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'rubocop-rails', require: false
  gem 'solargraph', '0.48.0'
  gem 'web-console', '4.2.0'
end

group :test do
  gem 'capybara',                 '3.38.0'
  gem 'guard',                    '2.18.0'
  gem 'guard-minitest',           '2.4.6'
  gem 'minitest',                 '5.18.0'
  gem 'minitest-reporters',       '1.6.0'
  gem 'rails-controller-testing', '1.0.5'
  gem 'selenium-webdriver',       '4.8.3'
  gem 'webdrivers',               '5.2.0'
end

group :production do
  gem 'pg', '1.3.5'
end
