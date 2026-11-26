# frozen_string_literal: true

# Headless-Chrome driver for the dummy app.
# Run from the repo root: bundle exec ruby .claude/skills/run-dummy-app/drive.rb
# Screenshots go to $OUT (default: $TMPDIR/loco-dummy-drive). Edit the steps at the bottom.

require 'fileutils'
require 'selenium-webdriver'
require 'tmpdir'

BASE = ENV.fetch('BASE', 'http://127.0.0.1:3456')
OUT = ENV.fetch('OUT', File.join(Dir.tmpdir, 'loco-dummy-drive'))
FileUtils.mkdir_p(OUT)

def browser
  opts = Selenium::WebDriver::Chrome::Options.new(args: %w[headless window-size=1280,1400])
  opts.add_option('goog:loggingPrefs', { browser: 'ALL' })
  Selenium::WebDriver.for(:chrome, options: opts)
end

# Screenshot + visible text + console output (minus loco's WS chatter).
def report(drv, name)
  sleep 1.5 # components render after the WS connects
  drv.save_screenshot(File.join(OUT, "#{name}.png"))
  puts "== #{name} (#{drv.current_url})"
  drv.find_element(tag_name: 'body').text.each_line { |l| puts "   #{l.strip[0, 160]}" }
  print_console(drv)
end

def print_console(drv)
  drv.logs.get(:browser)
     .reject { |l| l.level == 'DEBUG' || l.message =~ /WS (dis)?connected|uuid:|Object$/ }
     .each { |l| puts "   [console #{l.level}] #{l.message[0, 300]}" }
end

# path: '/user/sessions/new' or '/admin/sessions/new'
def login(drv, path, email, pass)
  drv.navigate.to "#{BASE}#{path}"
  drv.find_element(id: 'email').send_keys(email)
  drv.find_element(id: 'password').send_keys(pass)
  drv.find_element(css: 'input[type=submit]').click
  sleep 1
end

guest = browser
admin = browser
begin
  guest.navigate.to "#{BASE}/"
  report(guest, '01_home')

  login(admin, '/admin/sessions/new', 'admin@example.com', 'secret')
  admin.navigate.to "#{BASE}/admin/articles/published"
  report(admin, '02_admin_published')
ensure
  [guest, admin].each(&:quit)
end
