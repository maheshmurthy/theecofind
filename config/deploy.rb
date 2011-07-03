set :application, "theecofind"
set :repository,  "git@69.164.202.221:green.git"

set :scm, :git
set :deploy_via, :remote_cache

set :user, 'mahesh'
set :git_enable_submodules, true
set :copy_exclude, %w(.git)
set :shared_children, %w(log config system pids)

set :deploy_to, '/home/mahesh/applications/theecofind'

role :web, "69.164.202.221"                          # Your HTTP server, Apache/etc
role :app, "69.164.202.221"                          # This may be the same as your `Web` server
role :db, "69.164.202.221", :primary => true         # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

 namespace :deploy do
   desc "Restarting mod_rails with restart.txt"
   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
     run "touch #{current_path}/tmp/restart.txt" 
   end
 end

after "deploy:update_code", "db:symlink", "ts:symlink"

namespace :db do
  desc "Make symlink for database yaml"
  task :symlink, :except => { :no_release => true } do
    run <<-CMD
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
    CMD
  end
end

namespace :ts do
  desc "Make symlink for sphinx conf"
  task :symlink, :except => { :no_release => true } do
    run <<-CMD
      ln -nfs #{shared_path}/config/production.sphinx.conf #{release_path}/config/production.sphinx.conf;
      ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx
    CMD
  end

  desc "Reindex sphinx"
  task :reindex, :except => { :no_release => true } do
    run "cd #{current_path} && rake ts:reindex RAILS_ENV=production"
  end

  desc "Build sphinx index"
  task :index, :except => { :no_release => true } do
    run "cd #{current_path} && rake ts:index RAILS_ENV=production"
  end

  desc "Start sphinx daemon"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} && rake ts:start RAILS_ENV=production"
  end

  desc "Stop sphinx daemon"
  task :stop, :except => { :no_release => true } do
    run "cd #{current_path} && rake ts:stop RAILS_ENV=production"
  end
end
