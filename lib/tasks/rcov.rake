require "rspec/core/rake_task"

desc  "Run all specs with rcov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  rm "coverage.data" if File.exist?("coverage.data")  
  t.rcov = true
  t.rcov_opts = %w{--rails --exclude jsignal_internal,Gemfile,osx\/objc,gems\/,spec\/,yaml,yaml\/,rubygems/*,jruby/*,parser*,gemspec*,eval*,recognize_optimized* }
end
