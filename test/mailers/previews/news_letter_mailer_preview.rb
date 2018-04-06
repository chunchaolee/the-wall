# Preview all emails at http://localhost:3000/rails/mailers/news_letter_mailer
class NewsLetterMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/news_letter_mailer/weekly_notification
  def weekly_notification
    NewsLetterMailer.weekly_notification
  end

end
