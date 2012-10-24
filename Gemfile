source "http://rubygems.org"

# Declare your gem's dependencies in lightweight-activities.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
# gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# acts_as_list is a dependency of a few models in the dummy app and not
# of the engine itself, so it can stay here in the Gemfile and doesn't need
# to go into the Gemspec.
gem 'acts_as_list'
# Pry is sometimes useful for debugging
gem 'pry'
# Guard runs tests automatically when the files they test (or the tests
# themselves) change
gem 'guard-rspec'
# rb-fsevent is a Guard dependency
gem 'rb-fsevent'
# Rspec formatter
gem 'fuubar'
# dynamic_form shouldn't need to be here, because it's listed as a dependency
# in the .gemspec file, but when I take it out it breaks tests.
gem 'dynamic_form',         "~> 1.1.4"
# Likewise best_in_place seems to need to be in the Gemfile to show up in the
# assets build path.
gem 'best_in_place',        "~> 1.1.2"

# To use debugger
# gem 'debugger'
