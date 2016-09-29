ENV["RAILS_ENV"] = "test"
require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'capybara/rails'
require 'database_cleaner'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.fixtures :all
end

Capybara.javascript_driver = ENV['CAPYBARA_DRIVER'] ? ENV['CAPYBARA_DRIVER'].to_sym : :selenium
Capybara.current_driver = Capybara.javascript_driver
Capybara.default_max_wait_time = 5
Capybara.server = :puma

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

# Filter out Minitest backtrace while allowing backtrace from other libraries to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  if Rails.version.to_f >= 5
    self.use_transactional_tests = false
  else
    self.use_transactional_fixtures = false
  end

  fixtures :all

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end

class IT < ActionDispatch::IntegrationTest
  include Capybara::DSL
end