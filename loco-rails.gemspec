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

  s.required_ruby_version = '>= 3.1.0'

  s.add_dependency 'loco-rails-core', '~> 0.2.1'
  s.add_dependency 'rails', '>= 5.0'

  s.add_development_dependency 'bcrypt', '~> 3.1.20'
  s.add_development_dependency 'capybara', '~> 3.40.0'
  s.add_development_dependency 'database_cleaner', '~> 2.0.2'
  s.add_development_dependency 'jbuilder', '~> 2.11.5'
  s.add_development_dependency 'listen', '~> 3.8.0'
  s.add_development_dependency 'mysql2', '~> 0.5.5'
  s.add_development_dependency 'puma', '~> 6.4.2'
  s.add_development_dependency 'redis', '~> 5.0.8'
  s.add_development_dependency 'rspec-expectations', '~> 3.12.3'
  s.add_development_dependency 'rspec-mocks', '~> 3.12.6'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rails'
  s.add_development_dependency 'selenium-webdriver', '~> 4.17.0'
  s.add_development_dependency 'sprockets-rails', '~> 3.4.2'
  s.add_development_dependency 'will_paginate', '~> 4.0.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
