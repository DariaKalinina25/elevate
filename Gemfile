# frozen_string_literal: true

source 'https://rubygems.org'

# Core dependencies
gem 'devise'
gem 'faker'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.1'
gem 'slim-rails'

# Frontend & Hotwire
gem 'bootstrap', '~> 5.3', '>= 5.3.3'
gem 'dartsass-rails'
gem 'importmap-rails'
gem 'jbuilder'
gem 'propshaft'
gem 'stimulus-rails'
gem 'turbo-rails'

# Caching, background jobs, WebSockets
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

# Performance & optimization
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

# DevOps & deployment
gem 'kamal', require: false
gem 'thruster', require: false

group :development, :test do
  # Debugging & security
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Code quality & environment management
  gem 'dotenv-rails'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'rubocop-slim', require: false
  gem 'slim_lint', require: false

  # Testing
  gem 'capybara'
  gem 'cuprite'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'parallel_tests'
  gem 'rspec-rails', '~> 8.0'
  gem 'shoulda-matchers'
  gem 'test-prof'
end

group :development do
  # Development tools
  gem 'web-console'
end
