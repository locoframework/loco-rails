# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require_relative '../test/dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __dir__)
require 'rails/test_help'
require 'minitest/spec'
require 'capybara/rails'
require 'selenium/webdriver'
require 'database_cleaner'
require 'rspec/mocks'
require 'rspec/expectations'
require 'bcrypt'

# Filter out Minitest backtrace while allowing backtrace from other libraries to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [File.expand_path('fixtures', __dir__)]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.fixtures :all
end

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: [].tap do |arr|
      arr << 'headless' unless ENV.fetch('HEADLESS', nil) =~ /^(false|no|0)$/i
    end
  )
  Capybara::Selenium::Driver.new app, browser: :chrome, options:
end

Capybara.javascript_driver = :chrome
Capybara.current_driver = Capybara.javascript_driver
Capybara.default_max_wait_time = 5
Capybara.server = :puma

DatabaseCleaner.strategy = :truncation, { except: %w[ar_internal_metadata] }

module ActiveSupport
  class TestCase
    extend Minitest::Spec::DSL

    self.use_transactional_tests = false

    fixtures :all

    def setup
      Loco::WsConnectionStorage.current.storage.flushdb
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end
  end
end

class TCWithMocks < ActiveSupport::TestCase
  include ::RSpec::Mocks::ExampleMethods
  include ::RSpec::Matchers

  def before_setup
    ::RSpec::Mocks.setup
    super
  end

  def after_teardown
    super
    ::RSpec::Mocks.verify
  ensure
    ::RSpec::Mocks.teardown
  end
end

class IT < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def after_teardown
    Capybara.reset_session!
  end
end

TC = ActiveSupport::TestCase
