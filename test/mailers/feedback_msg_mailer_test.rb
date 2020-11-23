require 'test_helper'

class MessageMailerTest < ActionMailer::TestCase

  test "contact_me" do
    message = FeedbackMsg.new email: 'anna@example.org',
                          body: 'hello, how are you doing?'

    email = FeedbackMsgMailer.send_feedback(message)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal 'Loquar Feedback', email.subject
    assert_equal ['egoloquar@gmail.com'], email.to
    assert_equal ['anna@example.org'], email.from
    assert_match( /hello, how are you doing?/, email.body.encoded)
  end
end