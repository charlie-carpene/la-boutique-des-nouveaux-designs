source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4', '>= 5.4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'table_print'
  gem "letter_opener"
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
  gem 'rspec-rails', '~> 5.0', '>= 5.0.2'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'database_cleaner', '~> 2.0', '>= 2.0.1'
  gem 'rexml', '~> 3.2', '>= 3.2.5' #for rspec since ruby 3.0.0 doesnt use rexml by default
  gem 'bundler-audit', '~> 0.8.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.4', '>= 3.4.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'shoulda-matchers' #plugin for rspec
  gem 'simplecov', require: false
  gem 'stripe-ruby-mock', '~> 3.1.0.rc2', require: 'stripe_mock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise'
gem 'omniauth', '~> 2.0', '>= 2.0.4'
gem "content_disposition", "~> 1.0"

gem 'cancancan'

gem 'faker'

gem 'mailjet', :git => 'https://github.com/mailjet/mailjet-gem.git'
gem 'shrine', '~> 3.3'
gem 'fastimage', '~> 2.1', '>= 2.1.7'
gem 'image_processing', '~> 1.12'
gem 'mini_magick', '~> 4.10', '>= 4.10.1'
gem 'aws-sdk-s3', '~> 1.109'
gem 'migration_data', '~> 0.6.0'

gem 'stripe', '~> 5.22'
gem 'stripe_event', '~> 2.3', '>= 2.3.1'

gem 'faraday', '~> 1.3'
gem 'faraday_middleware', '~> 1.0'

gem 'view_component', '~> 2.49'
