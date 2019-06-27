# frozen_string_literal: true

ruby '2.6.2'

source 'https://rubygems.org'

git_source(:github) { |s| "https://github.com/#{s}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'.
gem 'rails', '~> 6.0.0.rc1'

# A set of common locale data and translations
# to internationalize and/or localize your Rails applications.
gem 'rails-i18n', '~> 6.0.0.beta1'

# Use postgresql as the database for Active Record.
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server.
gem 'puma', '~> 4.0'

# Use Uglifier as compressor for JavaScript assets.
gem 'uglifier', '>= 1.3.0'

# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks.
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder.
# gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production.
gem 'redis', '~> 4.1'

# Use ActiveModel has_secure_password.
gem 'bcrypt', '~> 3.1'

# Use ActiveStorage variant.
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb.
gem 'bootsnap', '>= 1.4.0', require: false

# Provides extended documentation support for the REPL
# by means of improving the `show-doc` and `show-source` commands.
# With help of the plugin the commands are be able to display the source code
# and the docs of Ruby methods and classes implemented in C.
gem 'pry-doc', '~> 1.0'

# Use Pry as your Rails console.
gem 'pry-rails', '~> 0.3'

# This gem provides jQuery and the jQuery-ujs driver
# for your Rails 4+ application.
gem 'jquery-rails', '~> 4.3'

# The most popular HTML, CSS, and JavaScript framework for developing
# responsive, mobile first projects on the web.
gem 'bootstrap', '~> 4.3.1'

# Font-Awesome SASS gem for use in Ruby projects.
gem 'font-awesome-sass', '~> 5.5.0'

# Forms made easy for Rails!
# It's tied to a simple DSL, with no opinion on markup.
gem 'simple_form', '~> 4.1'

# A simple HTTP and REST client for Ruby,
# inspired by the Sinatra microframework style of specifying actions:
# get, put, post, delete.
gem 'rest-client', '~> 2.0'

# A gem that provides a client interface for the Sentry error logger.
gem 'sentry-raven'

# Flexible authentication solution for Rails with Warden.
gem 'devise', '~> 4.6'

# Translations for the devise gem.
gem 'devise-i18n', '~> 1.8'

# Very simple Roles library without any authorization enforcement
# supporting scope on resource objects (instance or class).
# Supports ActiveRecord and Mongoid ORMs.
gem 'rolify', '~> 5.2'

# Object oriented authorization for Rails applications.
gem 'pundit', '~> 2.0'

# Interactor provides a common interface
# for performing complex user interactions.
gem 'interactor', '~> 3.1'

# A generalized Rack framework for multiple-provider authentication.
gem 'omniauth', '~> 1.9'

# Official OmniAuth strategy for GitHub.
gem 'omniauth-github', '~> 1.3'

# A rack middleware for throttling and blocking abusive requests.
gem 'rack-attack', '~> 6.0'

# Simple, efficient background processing for Ruby.
gem 'sidekiq', '~> 5.2'

# Helpers for the reCAPTCHA API.
gem 'recaptcha', '~> 4.13'

group :development, :test do
  # factory_bot provides a framework and DSL for defining and using factories.
  gem 'factory_bot_rails', '~> 4.10'

  # Faker is used to easily generate fake data:
  # names, addresses, phone numbers, etc.
  gem 'faker', '~> 1.8'

  # Automatic Ruby code style checking tool.
  # Aims to enforce the community-driven Ruby Style Guide.
  gem 'rubocop', '~> 0.67.2'

  # A collection of RuboCop cops
  # to check for performance optimizations in Ruby code.
  gem 'rubocop-performance', '~> 1.1'

  # rspec-rails is a testing framework for Rails 3+
  gem 'rspec-rails', '~> 3.8'

  # bundler-audit provides patch-level verification for Bundled apps.
  gem 'bundler-audit', '~> 0.6'

  # Brakeman detects security vulnerabilities
  # in Ruby on Rails applications via static analysis.
  gem 'brakeman', '~> 4.3'
end

group :development do
  # Capistrano is a utility and framework for executing commands in parallel
  # on multiple remote machines, via SSH.
  gem 'capistrano', '~> 3.11', require: false

  # RVM integration for Capistrano.
  gem 'capistrano-rvm', '~> 0.1', require: false

  # Rails specific Capistrano tasks.
  gem 'capistrano-rails', '~> 1.4', require: false

  # Remote Rails console for Capistrano.
  gem 'capistrano-rails-console', '~> 2.3', require: false

  # Call 'byebug' anywhere in the code to stop execution
  # and get a debugger console.
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # The Listen gem listens to file modifications
  # and notifies you about the changes. Works everywhere!
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running
  # in the background. Read more: https://github.com/rails/spring.
  gem 'spring'

  # Makes spring watch files using the listen gem.
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Automatically generate an entity-relationship diagram (ERD)
  # for your Rails models.
  gem 'rails-erd', '~> 1.5'

  # YARD is a documentation generation tool for the Ruby programming language.
  gem 'yard', '~> 0.9'

  # When mail is sent from your application,
  # Letter Opener will open a preview in the browser instead of sending.
  gem 'letter_opener', '~> 1.6'
end

group :test do
  # A Ruby implementation of the Coveralls API.
  gem 'coveralls', require: false

  # Strategies for cleaning databases.
  # Can be used to ensure a clean state for testing.
  gem 'database_cleaner', '~> 1.7'

  # Code coverage for Ruby 1.9+ with a powerful configuration library
  # and automatic merging of coverage across test suites.
  gem 'simplecov', '~> 0.16', require: false

  # Simple one-liner tests for common Rails functionality.
  gem 'shoulda-matchers', '4.0.0.rc1'

  # Cucumber Generator and Runtime for Rails.
  gem 'cucumber-rails', '~> 1.7', require: false

  # When a Cucumber step fails, it is useful to create a screenshot image
  # and HTML file of the current page.
  gem 'capybara-screenshot', '~> 1.0'

  # WebDriver is a tool for writing automated tests of websites.
  # It aims to mimic the behaviour of a real user,
  # and as such interacts with the HTML of the application.
  gem 'selenium-webdriver', '~> 3.14'

  # A set of RSpec matchers for testing Pundit authorization policies.
  gem 'pundit-matchers', '~> 1.6'
end
