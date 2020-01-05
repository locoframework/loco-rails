# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../test/dummy/config/environment.rb', __dir__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __dir__)
require 'rails/test_help'
require 'capybara/rails'
require 'database_cleaner'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.fixtures :all
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new app, browser: :chrome
end

Capybara.javascript_driver = :chrome
Capybara.current_driver = Capybara.javascript_driver
Capybara.default_max_wait_time = 5
Capybara.server = :puma

# Filter out Minitest backtrace while allowing backtrace from other libraries to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

DatabaseCleaner.strategy = :truncation, { except: %w[ar_internal_metadata] }

module Loco
  class UuidJob < ActiveJob::Base
    after_perform { |_| Ephemeron.reset }
  end

  class SenderJob < ActiveJob::Base
    after_perform { |_| Ephemeron.reset }
  end
end

module ActiveSupport
  class TestCase
    self.use_transactional_tests = false

    fixtures :all

    def setup
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
      Ephemeron.reset
    end
  end
end

class IT < ActionDispatch::IntegrationTest
  include Capybara::DSL
end
