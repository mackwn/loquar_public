class FeedbackMsgMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.feedback_msg_mailer.send_feedback.subject
  #
  def send_feedback(message,current_user)
    @body= message.body
    @l_id = message.lesson_id.nil? ? "nil" : message.lesson_id
    @q_id = message.question_id.nil? ? "nil" : message.question_id
    @user_email = current_user.email

    mail to: ENV["FEEDBACK_EMAIL"], subject: "Loquar Feedback", from: ENV["DO_NOT_REPLY_EMAIL"]
  end
end
