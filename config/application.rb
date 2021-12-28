require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LaBoutiqueDesNouveauxDesigns
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoload_paths << "#{Rails.root}/app/uploaders"
    config.autoload_paths << "#{Rails.root}/lib/"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.exceptions_app = self.routes

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :fr
    config.assets.precompile += [
      '@uppy/core/dist/style.css',
      '@uppy/dashboard/dist/style.css',
      '@uppy/image-editor/dist/style.css',
    ]

    # supports :s3, :s3_multipart, or :app
    config.upload_server = if ENV["UPLOAD_SERVER"].present?
      ENV["UPLOAD_SERVER"].to_sym
    elsif Rails.env.production?
      :s3
    else
      :app
    end
  end
end
