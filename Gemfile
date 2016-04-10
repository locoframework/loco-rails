source 'https://rubygems.org'

# Declare your gem's dependencies in loco.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :development, :test do
  gem 'jasmine', '~> 2.3'  # rake needs it here

  # integration tests need following gems in test group
  gem 'jquery-rails', '~> 4.0'
  gem 'turbolinks', '~> 2.5'
  gem 'jbuilder', '~> 2.0'
  gem 'eco', '~> 1.0'
  gem 'will_paginate', '~> 3.0'
end
