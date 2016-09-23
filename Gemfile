source 'http://rubygems.org'

gem 'rails', '~> 4.2.1'
gem 'mysql2', '~> 0.3.18'
gem 'pg', '~> 0.18.1'

gem 'unicorn', '~> 4.9.0'

gem 'sidekiq', '~> 3.3.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 4.1.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '~> 2.7.1'
  gem 'therubyracer', '~> 0.12.2'
end

gem 'best_in_place', '~> 3.0.3'
gem 'jquery-fileupload-rails', '~> 0.4.5'
gem 'sass-rails', '~> 5.0.3'
gem 'bootstrap-sass', '~> 3.3.4.1'

gem 'jquery-rails', '~> 4.0.3'
gem 'jquery-ui-rails', '~> 5.0.3'

gem 'less-rails', '~> 2.7.0' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS

gem 'rtf', '~> 0.3.3'

# NO LONGER NEEDED in ruby 1.9
# gem 'fastercsv'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'nifty-generators', '~> 0.4.6'

#require 'mysql2'

gem 'cocaine', '~> 0.5.7'
gem 'nokogiri', '~> 1.6.6.2'
gem 'expectr', '~> 2.0.2'
gem 'paperclip', '~> 4.2.1'
gem 'remotipart', '~> 1.2.1'
gem 'mime-types', '~> 2.5'

# Paperclip requires that ImageMagick is installed on the system

gem 'chosen-rails', '~> 1.4.1'
gem "compass-rails", github: "Compass/compass-rails", branch: "master"
gem 'spreadsheet', '~> 1.0.3'

gem 'rake', '~> 10.4.2'

gem 'authlogic', '~> 3.4.5'

gem 'omniauth', '~> 1.2.2'
gem 'omniauth-google-oauth2', '~> 0.2.6'
gem 'cancan', '~> 1.6.10'
gem 'redis-rails', '~> 4.0.0'

gem 'kaminari', '~> 0.16.3'

gem 'prawn', '~> 2.0.1'

gem 'soap4r', '~> 1.5.8'

gem 'simple_form', '~> 3.1.0'
gem 'roo', '~> 2.0.0'
# This gem is not directly used by the application
# However, it is common to automate items using this
# We simplify our clients' lives by including it in the package
gem 'selenium-client', '~> 1.2.18'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

#Only before applicaiton has been migrated to rails 5.0
gem 'protected_attributes'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
# gem "mocha", :group => :test
gem 'blitz'
gem 'test-unit'
group :development, :test do
  gem 'rspec-rails', '~> 3.2.1' 
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'capybara', '~> 2.4.4'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'thin', '~> 1.6.3'
end
