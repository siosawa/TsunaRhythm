require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
# Rails.loggerを出す
Rails.logger = Logger.new($stdout)
# SQLログ出す
ActiveRecord::Base.logger = Logger.new($stdout)
RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec/fixtures')
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # テスト用オブジェクトを生成する際にFactoryBotコードを省略する
  config.include FactoryBot::Syntax::Methods
end
