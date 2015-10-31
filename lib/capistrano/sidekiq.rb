# :sidekiq_default_hooks =>  true
# :sidekiq_pid =>  File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
# :sidekiq_env =>  fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
# :sidekiq_log =>  File.join(shared_path, 'log', 'sidekiq.log')
# :sidekiq_options =>  nil
# :sidekiq_require => nil
# :sidekiq_tag => nil
# :sidekiq_config => nil
# :sidekiq_queue => nil
# :sidekiq_timeout =>  10
# :sidekiq_role =>  :app
# :sidekiq_processes =>  1
# :sidekiq_concurrency => nil
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
set :sidekiq_queue, ['default', 'mailer']