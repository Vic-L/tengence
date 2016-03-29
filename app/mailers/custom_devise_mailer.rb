class CustomDeviseMailer < Devise::Mailer
  self.smtp_settings = {
    :address => ENV['MAIL_ADDRESS'],
    :port => 587,
    :user_name => ENV['ADMIN_MAIL_USERNAME'],
    :password => ENV['ADMIN_MAIL_PASSWORD'],
    :authentication => 'plain',
    enable_starttls_auto: true  }

  default from: "Tengence Team <hello@tengence.com.sg>"
  default reply_to: "hello@tengence.com.sg"

  def confirmation_instructions(record, token, opts={})
    @user = record
    @token = token
    mail(to: @user.email, subject: "Welcome to Tengence", template_path: 'users/mailer', template_name: 'confirmation_instructions')
  end
end