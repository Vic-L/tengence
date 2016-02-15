class CustomDeviseMailer < Devise::Mailer
  self.smtp_settings = {
    :address => ENV['MAIL_ADDRESS'],
    :port => 587,
    :user_name => ENV['ADMIN_MAIL_USERNAME'],
    :password => ENV['ADMIN_MAIL_PASSWORD'],
    :authentication => 'plain',
    enable_starttls_auto: true  }
end