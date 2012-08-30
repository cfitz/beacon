require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'will_paginate/array'
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


# Coverage currently not working in jruby.
#  unless ENV['DRB']
#    require 'simplecov'
#    SimpleCov.start 'rails'
#  end
  
  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    
    config.after(:each) do
      Neo4j.started_db.graph.getAllNodes.each do |n| 
        Neo4j::Transaction.run do
          unless n.id == 0
            n.rels.each { |r| r.delete unless r.nil? }
            n.delete unless n.nil?
          end
        end
      end
    end
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
    config.include Devise::TestHelpers, :type => :controller
    config.extend ControllerMacros, :type => :controller
  end

end

Spork.each_run do
  require 'factory_girl_rails'
  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
  end  
  # This code will be run each time you run your specs.
# coverage currently not working in jruby. waiting for 1.7
# unless ENV['DRB']
#    require 'simplecov'
#    SimpleCov.start 'rails'
#  end
  
end
