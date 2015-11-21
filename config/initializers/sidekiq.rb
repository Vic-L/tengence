Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new {|exception,context_hash| SidekiqErrorNotifier.notify(exception, context_hash) }
end
