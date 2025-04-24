ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Require Capybara libraries
require 'capybara/rails'
require 'capybara/minitest'

# Capybara Configuration
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome_headless

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
