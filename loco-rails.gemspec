# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

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

  s.required_ruby_version = '>= 2.6.0'

  s.add_dependency 'loco-rails-core', '~> 0.2.0'
  s.add_dependency 'rails', '>= 5.0'

  s.add_development_dependency 'bcrypt', '~> 3.1.16'
  s.add_development_dependency 'capybara', '~> 3.33.0'
  s.add_development_dependency 'database_cleaner', '~> 1.8.5'
  s.add_development_dependency 'jbuilder', '~> 2.10.1'
  s.add_development_dependency 'listen', '~> 3.3.3'
  s.add_development_dependency 'mysql2', '~> 0.5.3'
  s.add_development_dependency 'puma', '~> 5.5.1'
  s.add_development_dependency 'redis', '~> 4.2.2'
  s.add_development_dependency 'rspec-expectations', '~> 3.9.2'
  s.add_development_dependency 'rspec-mocks', '~> 3.9.1'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rails'
  s.add_development_dependency 'selenium-webdriver', '~> 3.142'
  s.add_development_dependency 'will_paginate', '~> 3.3.0'
end
