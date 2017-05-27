require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HomeDirect
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

# ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}
# File.open('/home/jerry/zzzzzzzz___111.txt', 'w') { |file| file.write( Rails.root) }
AppConfig = YAML.load_file( Rails.root.join( 'config' ,'application.yml'))[Rails.env] rescue {}
# File.open('/home/jerry/zzzzzzzz___222.txt', 'w') { |file| file.write( AppConfig['copyright']) }
