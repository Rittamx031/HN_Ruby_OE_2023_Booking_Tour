require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RailsTutorial
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.active_job.queue_adapter = :sidekiq
    config.time_zone = "UTC"
    config.generators do |g|
      g.test_framework = :rspec
    end
      config.generators do |g|
      g.test_framework(
        :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        route_specs: false,
      )
    end
  end
end
