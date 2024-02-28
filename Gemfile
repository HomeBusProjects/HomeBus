# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'pg'
gem 'puma', '~> 5.6.7'
gem 'rails', '~> 6.1.7.7'
gem 'sass-rails', '~> 5.0'
#gem 'uglifier', '>= 1.3.0'
gem 'terser'

# gem 'therubyracer'

gem 'actionview', '>= 6.1.7.3'
gem 'railties', '>= 6.1.7.3'

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
#  gem 'mini_racer'
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

# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bootstrap', '>= 5.1.3'

gem 'jquery-rails'

# gem 'whenever', require: false
# gem 'backup', require: false

gem 'bitfields'

gem 'letter_opener_web', '~> 1.0'

gem 'mqtt'
gem 'sidekiq'

gem 'bcrypt_pbkdf'
gem 'ed25519'
#gem 'net-ssh'
gem 'net-ssh', git: 'https://github.com/romkey/net-ssh-fixed'

gem 'brakeman', require: false
gem 'rubocop', require: false
gem 'rubocop-rails', require: false
gem 'nokogiri', '~> 1.14.3'
gem 'net-smtp'
gem 'net-pop'
gem 'net-imap'
