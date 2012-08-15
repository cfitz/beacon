require 'torquebox-capistrano-support'
require 'bundler/capistrano'

# SCM
set :application,       "http://ec2-23-20-125-106.compute-1.amazonaws.com/"
#set :repository,        "git@github.com:cfitz/beacon.git"
#set :branch,            "torquebox-2.0"
set :user,              "ec2-user"
set :scm,               :none
#set :scm_verbose,       true
#set :use_sudo,          false

# Production server
set :deploy_to,         "/opt/apps/myapp.com"
set :torquebox_home,    "/opt/torquebox/current"
set :jboss_init_script, "/etc/init.d/jboss-as-standalone"
set :app_environment,   "RAILS_ENV: production"
set :app_context,       "/"


ssh_options[:keys] = ["/Users/chrisfitzpatrick/Downloads.WMU_Cloud.pem"] unless 'development' == rails_env


#set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end