set :whenever_roles, -> { :web }
# set :whenever_command, -> { [:bundle, :exec, :whenever] }
# set :whenever_command_environment_variables, -> { {} }
# set :whenever_identifier, -> { fetch :application }
# set :whenever_environment, -> { fetch :rails_env, fetch(:stage, "production") }
# set :whenever_variables, -> { "environment=#{fetch :whenever_environment}" }
# set :whenever_update_flags, -> { "--update-crontab #{fetch :whenever_identifier} --set #{fetch :whenever_variables}" }
# set :whenever_clear_flags, -> { "--clear-crontab #{fetch :whenever_identifier}" }