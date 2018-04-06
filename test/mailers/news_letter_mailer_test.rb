require 'test_helper'

class NewsLetterMailerTest < ActionMailer::TestCase
  test "weekly_notification" do
    mail = NewsLetterMailer.weekly_notification
    assert_equal "Weekly notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
