class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.event_notification.subject
  #
  def event_notification(interest)
    @event = interest.event
    @user = interest.user

    mail to: @user.email, subject: "(#{@event.title}) will start soon!!"
  end
end
