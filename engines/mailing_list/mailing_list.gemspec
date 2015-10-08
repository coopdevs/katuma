$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mailing_list/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mailing_list"
  s.version     = MailingList::VERSION
  s.authors     = ["Katuma team"]
  s.email       = ["info@katuma.org"]
  s.homepage    = "http://www.katuma.org"
  s.summary     = "Mailing list management."
  s.description = "Mailing list management."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.7"
  s.add_dependency "gibbon", "2.0.0"
end
