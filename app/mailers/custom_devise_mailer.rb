class CustomDeviseMailer < Devise::Mailer
  self.smtp_settings = {
    :address => ENV['SENDGRID_ADDRESS'],
    :port => 587,
    :domain => ENV['SENDGRID_DOMAIN'],
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => 'plain',
    :enable_starttls_auto => true}

  default from: "Tengence Team <hello@tengence.com.sg>"
  default reply_to: "hello@tengence.com.sg"

  def confirmation_instructions(record, token, opts={})
    @user = record
    @token = token
    mail(to: @user.email, subject: "Welcome to Tengence", template_path: 'users/mailer', template_name: 'confirmation_instructions')
  end

  def reset_password_instructions record, token, opts={}
    @user = record
    @token = token
    mail(to: @user.email, subject: "Reset Password | Tengence", template_path: 'users/mailer', template_name: 'reset_password_instructions')
  end

  def password_changed id
    @user = User.find(id)
    mail to: @user.email, subject: "Your password has changed @ Tengence", template_path: 'users/mailer', template_name: 'password_changed'
  end
end