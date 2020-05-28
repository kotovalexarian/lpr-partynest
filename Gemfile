# frozen_string_literal: true

ruby '2.7.0'

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'aws-sdk-s3', require: false
gem 'bcrypt', '~> 3.1'
gem 'bootsnap', '>= 1.4.0', require: false
gem 'bootstrap', '~> 4.3.1'
gem 'devise', '~> 4.7'
gem 'devise-i18n', '~> 1.8'
gem 'font-awesome-sass', '~> 5.5.0'
gem 'interactor', '~> 3.1'
gem 'jquery-rails', '~> 4.3'
gem 'kaminari', '~> 1.2'
gem 'omniauth', '~> 1.9'
gem 'omniauth-github', '~> 1.3'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'pg', '~> 1.1'
gem 'pry-doc', '~> 1.1'
gem 'pry-rails', '~> 0.3'
gem 'puma', '~> 4.2'
gem 'pundit', '~> 2.1'
gem 'rack', '~> 2.2.0'
gem 'rack-attack', '~> 6.1'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
gem 'rails-i18n', '~> 6.0.0'
gem 'recaptcha', '~> 5.1'
gem 'redis', '~> 4.1'
gem 'rest-client', '~> 2.1'
gem 'sentry-raven'
gem 'sidekiq', '~> 6.0'
gem 'simple_form', '~> 5.0'
gem 'turbolinks', '~> 5.2'
gem 'uglifier', '>= 4.0'

# gem 'jbuilder', '~> 2.5'
# gem 'mini_magick', '~> 4.8'

group :development, :test do
  gem 'brakeman', '~> 4.3'
  gem 'bundler-audit', '~> 0.6'
  gem 'factory_bot_rails', '~> 4.10'
  gem 'faker', '~> 1.8'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', '~> 0.79.0'
  gem 'rubocop-performance', '~> 1.4'
  gem 'rubocop-rails', '~> 2.2'
  gem 'rubocop-rspec', '~> 1.36'
end

group :development do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rails-console', '~> 2.3', require: false
  gem 'capistrano-rvm', '~> 0.1', require: false
  gem 'letter_opener', '~> 1.6'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rails-erd', '~> 1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'yard', '~> 0.9', '>= 0.9.20'
end

group :test do
  gem 'capybara-screenshot', '~> 1.0'
  gem 'coveralls', require: false
  gem 'cucumber-rails', '~> 1.7', require: false
  gem 'database_cleaner', '~> 1.7'
  gem 'pundit-matchers', '~> 1.6'
  gem 'selenium-webdriver', '~> 3.14'
  gem 'shoulda-matchers', '~> 4.2'
  gem 'simplecov', '~> 0.16', require: false
  gem 'webmock', '~> 3.8'
end
