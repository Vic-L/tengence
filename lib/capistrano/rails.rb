namespace :rails do
  desc "Tail the log"
  task :tail do
    on roles(:app), primary: true do |host|
      command = "tail -n 100 -f #{fetch(:stage)}.log"
      exec "ssh -l #{host.user} #{host.hostname} -p #{22} -t 'cd #{deploy_to}/shared/log/ && #{command}'"
    end
  end
end