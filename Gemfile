source 'https://rubygems.org'

gem 'rails', '4.2.5'

gem 'oat', '0.4.6'

gem 'pg', '0.18.3'

gem 'doorkeeper', '3.0.1'

gem 'bcrypt-ruby', '3.1.5'

gem 'pundit', '1.0.1'

gem 'unicorn', '5.0.0'

gem 'haml', '4.0.7'

gem 'rails-i18n', '4.0.6'

gem 'email_validator', '1.6.0', require: 'email_validator/strict'

gemspec path: 'engines/shared'
gemspec path: 'engines/account'
gemspec path: 'engines/landing'
gemspec path: 'engines/group'
gemspec path: 'engines/producers'
gemspec path: 'engines/suppliers'
gemspec path: 'engines/onboarding'

gem 'mina', '0.3.7'
gem 'mina-unicorn', '0.3.0', require: false

group :assets do
  gem 'autoprefixer-rails', '6.1.0.1'
  gem 'sass-rails', '5.0.4'
  gem 'bootstrap-sass', '3.3.5.1'
  gem 'uglifier', '2.7.2'
end

group :test do
  gem 'rspec-rails', '3.3.3'
  gem 'rspec-its', '1.2.0'
  gem 'factory_girl_rails', '4.5.0'
  gem 'shoulda-matchers', '3.0.1', require: false
end

group :development, :test do
  gem 'byebug', '8.0.0'
end
