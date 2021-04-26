# frozen_string_literal: true

lock '~> 3.14.0'

set :application, 'HomeBus'
set :repo_url, 'git@github.com:romkey/HomeBus.git'
set :rbenv_ruby, '2.6.6'

set :whenever_roles, -> { [:db] }

current_branch = `git rev-parse --abbrev-ref HEAD`.strip
set :branch, ENV['branch'] || current_branch || 'master'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, '/home/homebus/HomeBus'

set :format, :airbrussh

append :linked_files, 'config/master.key'
append :linked_files, '.env'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', '.bundle'

task :update_backup_symlink do
  on roles(:db) do
    execute 'rm -f ~/Backup'
    execute "ln -s #{release_path}/backup ~/Backup"
  end
end

before 'whenever:update_crontab', :update_backup_symlink
