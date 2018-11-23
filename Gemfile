# frozen_string_literal: true

ruby '2.5.1'

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'.
gem 'rails', '~> 5.2.1'

# Use postgresql as the database for Active Record.
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server.
gem 'puma', '~> 3.11'

# Use SCSS for stylesheets.
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets.
gem 'uglifier', '>= 1.3.0'

# See https://github.com/rails/execjs#readme for more supported runtimes.
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks.
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder.
# gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production.
# gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password.
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant.
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment.
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb.
gem 'bootsnap', '>= 1.1.0', require: false

# Use Pry as your Rails console.
gem 'pry-rails', '~> 0.3'

# This gem provides jQuery and the jQuery-ujs driver
# for your Rails 4+ application.
gem 'jquery-rails', '~> 4.3'

# The most popular HTML, CSS, and JavaScript framework for developing
# responsive, mobile first projects on the web.
gem 'bootstrap', '~> 4.1.3'

# Font-Awesome SASS gem for use in Ruby projects.
gem 'font-awesome-sass', '~> 5.5.0'

group :development, :test do
  # factory_bot provides a framework and DSL for defining and using factories.
  gem 'factory_bot_rails', '~> 4.10'

  # Faker is used to easily generate fake data:
  # names, addresses, phone numbers, etc.
  gem 'faker', '~> 1.8'

  # Automatic Ruby code style checking tool.
  # Aims to enforce the community-driven Ruby Style Guide.
  gem 'rubocop', '~> 0.60.0'

  # rspec-rails is a testing framework for Rails 3+
  gem 'rspec-rails', '~> 3.8'
end

group :development do
  # Call 'byebug' anywhere in the code to stop execution
  # and get a debugger console.
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'listen', '>= 3.0.5', '< 3.2'

  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running
  # in the background. Read more: https://github.com/rails/spring.
  gem 'spring'

  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '~> 1.7'

  # Code coverage for Ruby 1.9+ with a powerful configuration library
  # and automatic merging of coverage across test suites.
  gem 'simplecov', '~> 0.16', require: false
end
