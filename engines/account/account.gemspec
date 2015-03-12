$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "account/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "account"
  s.version     = Account::VERSION
  s.authors     = ["katuma team"]
  s.email       = ["info@katuma.org"]
  s.homepage    = "http://www.katuma.org"
  s.summary     = "Account engine."
  s.description = "Account engine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.7"

  s.add_development_dependency "sqlite3"
end
