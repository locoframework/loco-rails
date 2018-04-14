# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __dir__)

require 'loco/version'

Gem::Specification.new do |s|
  s.name        = 'loco-rails'
  s.version     = Loco::VERSION
  s.authors     = ['Zbigniew Humeniuk']
  s.email       = ['hello@artofcode.co']
  s.homepage    = 'http://locoframework.org'
  s.summary     = 'Framework on top of Rails.'
  s.description = 'Rails is awesome, but modern web needs Loco-motive.'
  s.license     = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.rdoc'
  ]
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 5.0', '< 6.0'

  s.add_development_dependency 'bcrypt', '~> 3.1.7'
  s.add_development_dependency 'capybara', '>= 2.16.1', '< 4.0'
  s.add_development_dependency 'chromedriver-helper'
  s.add_development_dependency 'coffee-rails', '~> 4.2'
  s.add_development_dependency 'database_cleaner', '~> 1.6.1'
  s.add_development_dependency 'hirb', '~> 0.7'
  s.add_development_dependency 'listen', '>= 3.0.5', '< 3.2'
  s.add_development_dependency 'mysql2', '>= 0.3.18', '< 0.5'
  s.add_development_dependency 'puma', '~> 3.11'
  s.add_development_dependency 'redis', '~> 4.0.1'
  s.add_development_dependency 'sass-rails', '~> 5.0'
  s.add_development_dependency 'selenium-webdriver'
end
