lock "~> 3.11.0"

set :application, 'HomeBus'
set :repo_url, 'git@github.com:romkey/HomeBus.git'
set :rbenv_ruby, '2.6.2'

current_branch = `git rev-parse --abbrev-ref HEAD`.strip

# use the branch specified as a param, then use the current branch. If all fails use master branch
set :branch, ENV['branch'] || current_branch || "master" 

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, '/home/homebus/HomeBus'

set :format, :airbrussh

append :linked_files, 'config/master.key'
append :linked_files, '.env'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", '.bundle'


task :update_backup_symlink do
  on roles(:db) do
    execute :rm, "~/Backup"
    execute :ln, '-s', "#{latest_release}/backup", "~/Backup"
  end
end

before :whenever:update_crontab, :update_backup_symlink
