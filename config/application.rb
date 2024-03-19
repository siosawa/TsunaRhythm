require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.load_defaults 7.0

    # 以下を追加
    # デフォルトのロケールを日本語(:ja)に設定
    config.i18n.default_locale = :ja

    # ロケールファイルが格納されているディレクトリを指定
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.active_storage.variant_processor = :mini_magick
  end
end

