# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'pg'
gem 'puma', '~> 5.3.1'
gem 'rails', '~> 6.1.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# gem 'therubyracer'

gem 'actionview', '>= 6.0.0'
gem 'railties', '>= 6.0.0'

gem 'dotenv-rails'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'turbolinks', '~> 5'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'mini_racer'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end

# bcrypt 3.1.13 doesn't build properly on ARM architectures
gem 'bcrypt', '>= 3.1.16'
gem 'cancancan'
gem 'devise', '>= 4.7.1'
gem 'jwt'

# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bootstrap', '>= 4.3.1'

gem 'jquery-rails'

# gem 'whenever', require: false
# gem 'backup', require: false

gem 'bitfields'

gem 'letter_opener_web', '~> 1.0'

gem 'mqtt'
gem 'sidekiq'

gem 'bcrypt_pbkdf'
gem 'ed25519'
gem 'net-ssh'

gem 'brakeman', require: false
gem 'rubocop', require: false
gem 'rubocop-rails', require: false
