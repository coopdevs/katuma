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

  s.add_dependency "rails", "4.2.5"
  s.add_dependency 'pg', '0.18.3'

  s.add_development_dependency 'rspec-rails', '3.5.0'
  s.add_development_dependency 'byebug', '9.0.5'
  s.add_development_dependency 'rspec-its', '1.2.0'
  s.add_development_dependency 'shoulda-matchers', '3.0.1'
  s.add_development_dependency 'factory_girl_rails', '4.5.0'
end
