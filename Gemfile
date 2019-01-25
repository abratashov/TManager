source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'cancancan', '~> 2.0'
gem 'devise'
gem 'devise_token_auth'
gem 'omniauth'

gem 'acts_as_list'
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-i18n'
gem 'jsonapi-utils', '~> 0.7.0'
gem 'lol_dba'
gem 'swagger-docs'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'awesome_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Testing
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'json_spec'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.6'
  gem 'shoulda-matchers'

  gem 'bullet'

  gem 'rubycritic', require: false
  gem 'rubocop', '~> 0.51.0', require: false

  gem 'dotenv'
end

group :test do
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
