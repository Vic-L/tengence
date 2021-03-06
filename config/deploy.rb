# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'Tengence'
set :repo_url, 'git@bitbucket.org:zontext/tengence_alerts.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/tengence_alerts'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, false # false for sidekiq to work

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/shared')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 1

load "lib/capistrano/nginx.rb"
load "lib/capistrano/rails.rb"
load "lib/capistrano/whenever.rb"
load "lib/capistrano/sidekiq.rb"

namespace :deploy do
  after "deploy", "deploy:restart"
  after "deploy", "nginx:restart"

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end

namespace :maintenance do

  task :cleanup_past_tenders do
    on roles(:app) do
      within release_path do
        with :rails_env => fetch(:rails_env) do
          execute :rake, "maintenance:cleanup_past_tenders"
        end
      end
    end
  end

  task :refresh_cache do
    on roles(:app) do
      within release_path do
        with :rails_env => fetch(:rails_env) do
          execute :rake, "maintenance:refresh_cache"
        end
      end
    end
  end
  
end