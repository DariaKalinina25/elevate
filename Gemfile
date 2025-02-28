source "https://rubygems.org"

# Core dependencies
gem "rails", "~> 8.0.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# Frontend & Hotwire
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "propshaft"
gem "jbuilder"

# Caching, background jobs, WebSockets
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Performance & optimization
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

# DevOps & deployment
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  # Debugging & security
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false

  # Code quality & environment management
  gem "dotenv-rails"
end

group :development do
  # Development tools
  gem "web-console"
end
