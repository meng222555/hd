Rails.application.configure do
  config.react.variant = :development
  config.react.addons = true # defaults to false

  config.to_prepare do
    Devise::Mailer.helper :application
  end

  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  # config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  # config.action_mailer.delivery_method = :smtp # orig :test
  config.action_mailer.perform_deliveries = "#{AppConfig['mailer']['perform_deliveries']}" == "true" # true # false
  
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.action_mailer.delivery_method = :smtp
  # config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.default_url_options = { host: AppConfig['site']['hostname'], port: AppConfig['site']['port'], protocol: AppConfig['site']['protocol'] }

  ActionMailer::Base.smtp_settings = {
      :address        => AppConfig['mailer']['smtp_settings']['address'], # 'smtp.gmail.com',
      :port           => AppConfig['mailer']['smtp_settings']['port'], # '587',
      :authentication => AppConfig['mailer']['smtp_settings']['authentication'], # :plain,
      :user_name      => AppConfig['mailer']['smtp_settings']['user_name'], # 'ming222555@gmail.com',
      :password       => AppConfig['mailer']['smtp_settings']['password'], # 'atthezoo123',
      :domain         => AppConfig['mailer']['smtp_settings']['domain'], # 'gmail.com',
      :enable_starttls_auto => "#{AppConfig['mailer']['smtp_settings']['enable_starttls_auto']}" == "true"
  }


  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
