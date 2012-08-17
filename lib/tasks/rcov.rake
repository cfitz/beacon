# Forked to get it working with Rails 3 and RSpec 2
#
# From http://github.com/jaymcgavren
#
# Save this as rcov.rake in lib/tasks and use rcov:all =>
# to get accurate spec/feature coverage data
#
# Use rcov:rspec or rcov:steak
# to get non-aggregated coverage reports for rspec or steak separately

begin
  require "rspec/core/rake_task"

  namespace :rcov do
    RSpec::Core::RakeTask.new(:steak_run) do |t|
      t.rcov = true
      t.rcov_opts = %w{--rails --exclude gems\/,spec\/,acceptance\/ --aggregate coverage.data}
      t.rcov_opts << %[-o "coverage"]
    end

    RSpec::Core::RakeTask.new(:rspec_run) do |t|
      t.pattern = 'spec/**/*_spec.rb'
      t.rcov = true
      t.rcov_opts = %w{--rails --exclude gems\/,spec\/}
    end

    desc "Run both specs and features to generate aggregated coverage"
    task :all do |t|
      rm "coverage.data" if File.exist?("coverage.data")
      Rake::Task["rcov:steak_run"].invoke
      Rake::Task["rcov:rspec_run"].invoke
    end

    desc "Run only rspecs"
    task :rspec do |t|
      rm "coverage.data" if File.exist?("coverage.data")
      Rake::Task["rcov:rspec_run"].invoke
    end

    desc "Run only steak"
    task :steak do |t|
      rm "coverage.data" if File.exist?("coverage.data")
      Rake::Task["rcov:steak_run"].invoke
    end
  end
rescue LoadError
  puts "RSPEC IS NOT INSTALL BIATCH!!!!!"
end
  