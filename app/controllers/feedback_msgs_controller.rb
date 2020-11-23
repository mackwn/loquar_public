class FeedbackMsgsController < ApplicationController
    def new
        redirect_to root_path and return if !(user_signed_in?)
        @message = FeedbackMsg.new
    end
    
    def create
        redirect_to root_path and return if !(user_signed_in?)
        @message = FeedbackMsg.new message_params

        if @message.valid?
          FeedbackMsgMailer.send_feedback(@message,current_user).deliver_now
          respond_to do |format|
              format.html { redirect_to new_feedback_msg_url, notice: "Message received, thanks!" }
              format.js {@sent = true}
          end
          #redirect_to new_feedback_msg_url, notice: "Message received, thanks!"
        else
            respond_to do |format|
                format.html { render :new }
                #format.json { render json: @lesson.errors, status: :unprocessable_entity }
                format.js {@sent = false}
            end
        end
    end
    
     private

    def message_params
        params.require(:feedback_msg).permit(:email, :body, :lesson_id, :question_id)
    end
    
    
end
