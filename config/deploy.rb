require 'torquebox-capistrano-support'
require 'bundler/capistrano'



# SCM
server       "195.178.246.38", :web, :app, :primary => true
set :repository,        "git@github.com:cfitz/beacon.git"
set :branch,            "master"
set :user,              "torquebox"
set :scm,               :git
set :scm_verbose,       true
set :use_sudo,          false
#set :bundle_dir, '/opt/apps/beacon.se/shared/bundle'

# Production server
set :deploy_to,         "/opt/apps/beacon.se"
set :torquebox_home,    "/opt/torquebox/current"
set :jboss_init_script, "/etc/init.d/jboss-as-standalone"
set :rails_env, 'production'
set :app_context,       "/"
set :app_ruby_version, '1.9'
set :application, "195.178.246.38"

default_environment['JRUBY_OPTS'] = '--1.9'
default_environment['PATH'] = '/opt/torquebox/current/jboss/bin:/opt/torquebox/current/jruby/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin:/root/bin'



default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :deploy_via, :remote_cache
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "aws_key.pem")]


namespace :deploy do
  desc "relink db directory"
   #if you use sqlite
   task :resymlink, :roles => :app do
     run "rm -rf #{current_path}/db && ln -s /opt/db #{current_path}/db && chown -R torquebox:torquebox  #{current_path}/db"
   end
   
   
namespace :deploy do
    namespace :assets do
      task :precompile, :roles => :web, :except => { :no_release => true } do
        from = source.next_revision(current_revision)
        logger.info "cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l"
        if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
          logger.info "Doing the precompile jig"
          run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
        else
          logger.info "Skipping asset pre-compilation because there were no asset changes"
        end
    end
  end
end


 
end

after 'deploy:update', 'deploy:resymlink'