class FeedbackMsg 
    include ActiveModel::Model
    attr_accessor :email, :body, :lesson_id, :question_id
    validates :email, :body, presence: true 
    validates :body, :length => { :maximum => 2000 }
end
