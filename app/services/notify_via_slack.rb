class NotifyViaSlack
  include Service
  include Virtus.model

  attribute :channel, String
  attribute :content, String

  def call
    begin
      if Rails.env.production?
        notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'], username: 'Alerts-Tengence', channel: channel || "#alerts-tengence-pings")
        notifier.ping content
      elsif Rails.env.development?
        notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'], username: 'Alerts-Tengence', channel: "#tengence-dev")
        notifier.ping content
      else
        puts "\r\n>>>>>>>Slack notification to #{channel || '#alerts-tengence-pings'}:\r\n#{content}\r\n>>>>>>>\r\n\r\n"
      end
    rescue => e
      InternalMailer.notify("Error NotifyViaSlack.rb", "#{e.message}\r\n\r\n#{e.backtrace.to_s}")
    end
  end
end