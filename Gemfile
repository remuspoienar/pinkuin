ruby '2.5.1'

source 'https://rubygems.org'

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'

# authentication
gem 'devise'

# authorization
gem 'pundit'
gem 'rolify'

# fonts
gem 'font-awesome-rails'

# pagination
gem 'kaminari'

# templating
gem 'haml'

# forms
gem 'simple_form'

# frontend
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass'
gem 'bourbon'

gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'

# background processing
gem 'sidekiq'

# other
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 3.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'

  gem 'faker'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'

  gem 'rspec-rails'
  gem 'cucumber-rails', require: false

  gem 'email_spec'

  gem 'bullet'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'web-console', '>= 3.3.0'

  gem 'brakeman'
  gem 'guard-rspec', require: false
  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'formulaic'
  gem 'climate_control'
end

group :production do
  gem 'rails_12factor'
  gem 'puma', '~> 3.7'
end