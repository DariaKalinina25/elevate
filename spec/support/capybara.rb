# frozen_string_literal: true

require 'capybara/cuprite'

Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(
    app,
    headless: true,
    window_size: [1200, 800],
    timeout: 15,
    process_timeout: 15
  )
end

Capybara.default_max_wait_time = 5
