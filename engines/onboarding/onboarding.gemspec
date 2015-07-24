$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "onboarding/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "onboarding"
  s.version     = Onboarding::VERSION
  s.authors     = ["katuma team"]
  s.email       = ["info@katuma.org"]
  s.homepage    = "http://www.katuma.org"
  s.summary     = "Onbording engine."
  s.description = "Onbording engine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.1.7"
end
