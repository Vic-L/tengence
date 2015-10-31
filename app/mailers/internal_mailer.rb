class InternalMailer < ApplicationMailer
  def notify subject, content, to_target="tengencesingapore@gmail.com"
    @subject, @content = subject, content
    mail(from: 'notification@tengence.com.sg', to: to_target, subject: @subject, cc: 'vljc17@gmail.com')
  end
end
