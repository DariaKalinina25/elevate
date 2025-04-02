# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'factory_bot_rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# Shoulda Matchers
Shoulda::Matchers.configure do |matcher_config|
  matcher_config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Loading all support files
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

RSpec.configure do |config|
  # General helpers
  config.include FactoryBot::Syntax::Methods
  config.include TestHelpers
  config.include I18nTestHelper
  config.include SystemHelpers, type: :system

  # System specs
  config.before(:each, type: :system) { driven_by :rack_test }
  config.before(:each, :js, type: :system) { driven_by :cuprite }

  # DatabaseCleaner
  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }

  config.before do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after { DatabaseCleaner.clean }

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
