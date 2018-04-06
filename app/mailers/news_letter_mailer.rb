class NewsLetterMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.news_letter_mailer.weekly_notification.subject
  #
  def weekly_notification
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
