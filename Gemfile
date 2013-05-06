source 'https://rubygems.org'
gem 'jruby-openssl', '0.7.7'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'neo4j'
#gem 'neo4j-core', :git => 'git://github.com/andreasronge/neo4j-core.git'
gem "torquebox-rake-support"
gem "devise", ">= 2.2.0"
gem 'devise-neo4j', :git => "git@github.com:cfitz/devise-neo4j.git"
#gem 'devise-neo4j', :path => "/Users/chrisfitzpatrick/code/devise-neo4j"
gem 'omniauth-google-oauth2', '0.1.13'
gem 'marc'
gem "haml-rails"
gem 'tire'
gem 'neo4j-will_paginate'
gem 'will_paginate'
gem 'simple_form'
gem "nested_form"
gem 'rtika'
gem 'google_drive', '0.3.3'


group :test, :development do
#  gem 'neo4j-admin', :git => "git://github.com/andreasronge/neo4j-admin.git"
   gem 'torquebox', '2.1.0'
   gem 'torquebox-capistrano-support'
   gem 'ZenTest', "4.8.3"
   gem 'rspec-rails','2.11.0'
   gem 'guard-rspec','0.5.5'
   gem 'autotest-rails'
   gem 'autotest-fsevent'
   gem 'autotest-growl'
end

group :test do
  gem 'simplecov', :require => false
	gem 'capybara','1.1.2'
	gem 'factory_girl_rails', '~> 3.5.0', require: false
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner', :git => "https://github.com/cfitz/database_cleaner.git"     #, '0.7.0'
	gem 'guard-spork', '0.3.2'
	gem 'spork', '0.9.0'
	gem 'launchy', '2.1.0'
	gem "email_spec", ">= 1.4.0"
	gem 'rb-fsevent', '0.9.1', :require => false
 	gem 'growl', '1.0.3'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyrhino'
  gem "less-rails"
  gem 'twitter-bootstrap-rails'
  #, :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git"
  #, :branch => "static"
	
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

 

  gem 'uglifier', '1.2.6'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'