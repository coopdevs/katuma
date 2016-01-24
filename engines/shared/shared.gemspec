$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "shared/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shared"
  s.version     = Shared::VERSION
  s.authors     = ["katuma team"]
  s.email       = ["info@katuma.org"]
  s.homepage    = "http://www.katuma.org"
  s.summary     = "Shared engine."
  s.description = "Shared engine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir['spec/**/*']

  s.add_dependency "rails", "4.2.5"

  s.add_development_dependency 'rspec-rails', '~> 3.4'
end
