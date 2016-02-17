ENV["RAILS_ENV"] = "test"
require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'capybara/rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.fixtures :all
end

Capybara.javascript_driver = ENV['CAPYBARA_DRIVER'] ? ENV['CAPYBARA_DRIVER'].to_sym : :selenium
Capybara.current_driver = Capybara.javascript_driver
Capybara.default_max_wait_time = 5

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

# Filter out Minitest backtrace while allowing backtrace from other libraries to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Make all database transactions use the same thread
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    Thread.main.object_id
  end
end

class IT < ActionDispatch::IntegrationTest
  include Capybara::DSL
end