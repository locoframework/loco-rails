# frozen_string_literal: true

require 'capybara/selenium/driver'

# Capybara 3.40's reset! clears storage with Storage.clearDataForOrigin(origin: '*'),
# which Chrome 158+ rejects ("* is not a valid URL"), failing every browser test at teardown.
# Tests only ever visit the Capybara server, so clearing its origin is equivalent.
# ponytail: drop once a Capybara release stops sending '*'
module ChromeResetOrigin
  private

  def execute_cdp(cmd, params = {})
    params = params.merge(origin: Capybara.current_session.server.base_url) if params[:origin] == '*'
    super
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend ChromeResetOrigin
