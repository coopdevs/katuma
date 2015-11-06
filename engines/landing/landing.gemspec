$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "landing/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "landing"
  s.version     = Landing::VERSION
  s.authors     = ["katuma team"]
  s.email       = ["info@katuma.org"]
  s.homepage    = "http://www.katuma.org"
  s.summary     = "Landing engine."
  s.description = "Landing engine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.2.4"
end
