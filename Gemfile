source 'https://rubygems.org'

gem 'rails', '4.2.5'

gem 'pg', '0.18.3'

gem 'doorkeeper', '3.0.1'

gem 'pundit', '1.0.1'

gem 'haml', '4.0.7'

gem 'rails-i18n', '4.0.6'

# Background processing
gem 'sidekiq', '4.0.1'

gemspec path: 'engines/shared'
gemspec path: 'engines/account'
gemspec path: 'engines/basic_resources'
gemspec path: 'engines/producers'
gemspec path: 'engines/suppliers'
gemspec path: 'engines/onboarding'

gem 'mina', '0.3.7'

gem 'autoprefixer-rails', '6.1.0.1'
gem 'sass-rails', '5.0.4'
gem 'bootstrap-sass', '3.3.5.1'
gem 'uglifier', '2.7.2'

group :test do
end

group :development, :test do
  gem 'byebug', '9.0.5'
  gem 'pry-byebug', '3.4.0'
end

group :production do
  gem 'unicorn', '5.0.0'
end
