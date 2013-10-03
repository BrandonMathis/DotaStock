load 'deploy/assets'
require 'bundler/capistrano'

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

set :application, 'DotaStock'
set :repository,  'git://github.com/BrandonMathis/DotaStock.git'
set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, 'brandonmathis.me'                          # Your HTTP server, Apache/etc
role :app, 'brandonmathis.me'                          # This may be the same as your `Web` server
role :db,  'brandonmathis.me', :primary => true # This is where Rails migrations will run

set :user, 'bemathis'
set :ssh_options, { :port => 44, :forward_agent => true }

default_run_options[:pty] = true

set :deploy_to, '/var/www/DotaStock'
set :deploy_via, :remote_cache
set :copy_cache, true
set :copy_exclude, [".git"]
set :copy_compression, :bz2

set :scm, :git
set :scm_verbose, true
set(:current_branch) { `git branch`.match(/\* (\S+)\s/m)[1] || raise("Couldn't determine current branch") }
set :branch, defer { current_branch }

after 'deploy:finalize_update', 'deploy:make_links'
after "deploy:update_code", "deploy:migrate"

namespace :deploy do
  desc 'Symlinks the database.yml'
  task :make_links, roles: :app do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/api_config.yml #{release_path}/config/api_config.yml"
  end

  task :get_hero_information do
    run("cd #{deploy_to}/current && /usr/bin/env bundle exec rake get_hero_information RAILS_ENV=production")
  end

  task :start_collector do
    run("cd #{deploy_to}/current && /usr/bin/env bundle exec rake start_collector RAILS_ENV=production")
  end

  task :stop_collector do
    run("cd #{deploy_to}/current && /usr/bin/env bundle exec rake stop_collector RAILS_ENV=production")
  end
end

after "deploy:restart", "deploy:cleanup"

set :rails_env, :production
set :unicorn_binary, 'bundle exec unicorn_rails'
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
