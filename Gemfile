# frozen_string_literal: true

ruby '2.7.0'

source 'https://rubygems.org'

git_source(:github) { |s| "https://github.com/#{s}.git" }

gem 'rails', '~> 6.0.0'
gem 'rack', '= 2.2.0', github: 'rack/rack'
gem 'rails-i18n', '~> 6.0.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 4.2'
gem 'uglifier', '>= 4.0'
gem 'turbolinks', '~> 5.2'
# gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 4.1'
gem 'bcrypt', '~> 3.1'
# gem 'mini_magick', '~> 4.8'
gem 'bootsnap', '>= 1.4.0', require: false
gem 'pry-doc', '= 1.0.0', github: 'pry/pry-doc'
gem 'pry-rails', '~> 0.3'
gem 'jquery-rails', '~> 4.3'
gem 'bootstrap', '~> 4.3.1'
gem 'font-awesome-sass', '~> 5.5.0'
gem 'simple_form', '~> 5.0'
gem 'rest-client', '~> 2.1'
gem 'sentry-raven'
gem 'devise', '~> 4.7'
gem 'devise-i18n', '~> 1.8'
gem 'pundit', '~> 2.1'
gem 'interactor', '~> 3.1'
gem 'omniauth', '~> 1.9'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'omniauth-github', '~> 1.3'
gem 'rack-attack', '~> 6.1'
gem 'sidekiq', '~> 6.0'
gem 'recaptcha', '~> 5.1'
gem 'kaminari', '~> 1.1'
gem 'aws-sdk-s3', require: false
gem 'elasticsearch-model', '~> 7.0'
gem 'elasticsearch-rails', '~> 7.0'

group :development, :test do
  gem 'factory_bot_rails', '~> 4.10'
  gem 'faker', '~> 1.8'
  gem 'rubocop', '~> 0.79.0'
  gem 'rubocop-performance', '~> 1.4'
  gem 'rubocop-rails', '~> 2.2'
  gem 'rubocop-rspec', '~> 1.36'
  gem 'rspec-rails', '~> 3.8'
  gem 'bundler-audit', '~> 0.6'
  gem 'brakeman', '~> 4.3'
end

group :development do
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-rvm', '~> 0.1', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rails-console', '~> 2.3', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd', '~> 1.5'
  gem 'yard', '~> 0.9', '>= 0.9.20'
  gem 'letter_opener', '~> 1.6'
end

group :test do
  gem 'coveralls', require: false
  gem 'database_cleaner', '~> 1.7'
  gem 'simplecov', '~> 0.16', require: false
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'cucumber-rails', '~> 1.7', require: false
  gem 'capybara-screenshot', '~> 1.0'
  gem 'selenium-webdriver', '~> 3.14'
  gem 'pundit-matchers', '~> 1.6'
  gem 'webmock', '~> 3.8'
end
