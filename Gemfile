# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6' # Make sure that this matches .ruby-version file.

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.8.1'
# Use Puma as the app server
gem 'puma'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# Note: Pin the webpacker version to the same version used in package.json
gem 'webpacker', '5.1.1'
# Use assets pipeline to serve topojson files.
gem 'sprockets', '4.0.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use third party sign on authenticate users
gem 'omniauth', github: 'omniauth/omniauth'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# Use Haml instead of erb
gem 'haml-rails'

# Google Civic Client
gem 'google-api-client', '~> 0.34'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Even though this gem is only required for rake tasks, heroku needs it to run
# pre-receive rake tasks hook so it is included for production environment.
gem 'rubyzip'

gem 'date_validator'

group :development, :test do
  gem 'axe-core-cucumber'
  gem 'axe-core-rspec'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'sqlite3'

  # Guard Plugins
  gem 'guard'
  gem 'guard-cucumber', require: false
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false

  # Generate different sizes of favicon from a single image.
  gem 'rails_real_favicon'

  # Report coverage.
  gem 'codecov', require: false
  gem 'simplecov'
end

# Define a group which includes 'linters'
# This allows you to install just the linter gems in certain environments.
group :development, :test, :linters do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # You may which to move these to the "default" group to use in production.
  gem 'byebug'
  gem 'pry'
  gem 'pry-byebug'

  # Linters and static analysis.
  gem 'haml-lint', require: false
  # Tool to run all the linters
  gem 'pronto', require: false
  gem 'pronto-flay', require: false
  gem 'pronto-haml', require: false
  gem 'pronto-rubocop', require: false
  gem 'rubocop', require: false
  gem 'rubocop-faker', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  # Use postgresql as the database for Active Record in production (Heroku)
  gem 'pg', '>= 0.18', '< 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
