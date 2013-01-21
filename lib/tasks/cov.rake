
begin



  require 'simplecov'
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'

  namespace :cov do
   
    desc "Run cucumber & rspec to generate aggregated coverage"
    task :all do |t|
      SimpleCov.start 'rails'
      rm "coverage/coverage.data" if File.exist?("coverage/coverage.data")
      Rake::Task['spec'].invoke
      Rake::Task["cucumber"].invoke
    end
  end
  
rescue LoadError
    desc 'cov rake task not available (simplecov not installed)'
    task :cov do
      abort 'Cov rake task is not available. SimpleCov is not installed'
    end
  end