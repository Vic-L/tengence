class SidekiqErrorNotifier

  def self.notify(exception, context_hash)
    NotifyViaSlack.call(content: "<@vic-l> Sidekiq Error: #{context_hash['class']}\r\n" + exception.message + "\r\n\r\n" + context_hash.map{|k,v| "#{k.to_s} => #{v.to_s}"}.join("\n") + "\r\n\r\n" + exception.backtrace.to_s)
  end

end
