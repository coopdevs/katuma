$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "producers/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "producers"
  s.version     = Producers::VERSION
  s.authors     = ["katuma team"]
  s.email       = ["info@katuma.org"]
  s.homepage    = "http://www.katuma.org"
  s.summary     = "Producers engine."
  s.description = "Producers management engine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "README.rdoc"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '~> 4.2.5'
  s.add_dependency 'sqlite3', '~> 1.3', '>= 1.3.11'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
end
