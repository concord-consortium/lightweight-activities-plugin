$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lightweight/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lightweight_activities"
  s.version     = Lightweight::VERSION
  s.authors     = ["Aaron Unger"]
  s.email       = ["aunger@concord.org"]
  s.homepage    = "http://www.concord.org/"
  s.summary     = "Lightweight activity models and views for use in the CC rails portal"
  s.description = "Models to describe the structure of simple, lightweight activities, along with the views necessary to render them in a browser."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  # make sure to match gem versions with the portal
  s.add_dependency "rails", "~> 3.2.6"
  s.add_dependency "haml", "~> 3.1.4"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec",       "~> 2.10.0"
  s.add_development_dependency "rspec-rails", "~> 2.10.1"
  s.add_development_dependency "ci_reporter", "~> 1.7.0"
  s.add_development_dependency "uglifier"
end
