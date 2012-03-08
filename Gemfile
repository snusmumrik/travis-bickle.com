source 'http://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '  ~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'parallel_tests'
  gem 'metric_fu'
  gem 'rails3-generators'
  gem 'capybara'
  gem 'cucumber-rails' # rails generate cucumber:install --capybara --rspec --spork
  gem 'database_cleaner' # database_cleaner is not required, but highly recommended
  gem 'i18n_generators', :git => 'git://github.com/amatsuda/i18n_generators'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'guard-rspec'
  gem 'spork', '>=0.9.0.rc2'
  gem 'minitest'
  gem 'factory_girl_rails'
end

gem 'devise'
gem "omniauth"
gem 'oa-oauth', :require => "omniauth/oauth"
gem 'activeadmin'
gem 'meta_search', '>= 1.1.0.pre'
gem 'kaminari'