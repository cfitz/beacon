require 'torquebox-capistrano-support'
require 'bundler/capistrano'



# SCM
server       "ec2-50-19-208-69.compute-1.amazonaws.com", :web, :app, :primary => true
set :repository,        "git@github.com:cfitz/beacon.git"
set :branch,            "torquebox"
set :user,              "root"
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
set :application, "ec2-50-19-208-69.compute-1.amazonaws.com"

default_environment['JRUBY_OPTS'] = '--1.9'
default_environment['PATH'] = '/opt/torquebox/current/jboss/bin:/opt/torquebox/current/jruby/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin:/root/bin'



default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :deploy_via, :remote_cache
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "aws_key.pem")]

