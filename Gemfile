source 'https://rubygems.org'

gem 'rails', '4.1.7'

gem 'oat', '~> 0.4.5'

gem 'pg'

gem 'doorkeeper', '2.1.3'

gem 'bcrypt-ruby', '~> 3.1.5'

gem 'pundit'

# Server recommended for run apps in Heroku is Puma
# Also they recomment manage app start with foreman
gem 'foreman'
gem 'puma'

gemspec path: "engines/shared"
gemspec path: "engines/account"
gemspec path: "engines/landing"

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
end

group :test do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'rspec-its', '~> 1.1.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'shoulda-matchers', '~> 2.7.0', require: false
end

group :development, :test do
  gem 'byebug'
end

group :production do
  gem 'rails_stdout_logging'
end
