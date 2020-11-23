# Preview all emails at http://localhost:3000/rails/mailers/feedback_msg_mailer
class FeedbackMsgMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/feedback_msg_mailer/send_feedback
  def send_feedback
    message = FeedbackMsg.new  email: 'marflar@example.org',
                          body: 'This is the body of the email'

    FeedbackMsgMailer.send_feedback message
  end

end
