set :application, "slowmonster"
set :repository,  "git@github.com:composit/slowmonster.git"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :deploy_via, :remote_cache
set :use_sudo, false

require 'capistrano/ext/multistage'
set :stages, %w( staging production )
set :default_stage, 'staging'

require 'rvm/capistrano'
set :rvm_ruby_string, '2.0.0-p247'
set :rvm_type, :system

require 'bundler/capistrano'
require 'capistrano/npm'

set :scm, :git

server "murder", :app, :web, :db, :primary => true

unicorn_pid = "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
end

after "deploy:restart", "deploy:cleanup"

after 'deploy:update_code' do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

before 'deploy:assets:precompile' do
  'npm:install'
  run "ln -nfs #{deploy_to}/shared/config/application.yml #{release_path}/config/application.yml"
end

#namespace :db do
#  task :create do
#    #run("cd #{deploy_to}/current && /usr/bin/env rake db:create RAILS_ENV=production")
#    run("cd #{deploy_to}/current && #{rake} db:create RAILS_ENV=#{rails_env}")
#  end
#end
