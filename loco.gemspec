$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "loco/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "loco"
  s.version     = Loco::VERSION
  s.authors     = ["himn1"]
  s.email       = ["zbigniew.humeniuk@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Loco."
  s.description = "TODO: Description of Loco."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "sqlite3"
end
