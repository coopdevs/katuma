$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "public_pages/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "public_pages"
  s.version     = PublicPages::VERSION
  s.authors     = ["Enrico Stano"]
  s.email       = ["info@katuma.org"]
  s.homepage    = "http://www.katuma.org"
  s.summary     = "Public pages for Katuma.org"
  s.description = "Public pages for Katuma.org"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "4.1.7"
end
