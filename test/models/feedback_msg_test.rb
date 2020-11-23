require 'test_helper'

class FeedbackMsgTest < ActiveSupport::TestCase
  test 'responds to name, email and body' do 
    msg = FeedbackMsg.new

    assert msg.respond_to?(:email), 'does not respond to :email'
    assert msg.respond_to?(:body),  'does not respond to :body'
    assert msg.respond_to?(:lesson_id),  'does not respond to :lesson_id'
    assert msg.respond_to?(:question_id),  'does not respond to :question_id'
  end
  
  test 'should be valid when all required attributes are set' do
    attrs = { 

      email: 'stephen@example.org',
      body: 'kthnxbai'
    }

    msg = FeedbackMsg.new attrs
    assert msg.valid?, 'should be valid'
  end
  
  test 'body size should be limited' do
    @body_text = 'a'*5000
    attrs = { 

      email: 'stephen@example.org',
      body: @body_text
    }

    msg = FeedbackMsg.new attrs
    refute msg.valid?, 'should not be valid'
  end
  
  test 'email and body are required by law' do
    msg = FeedbackMsg.new

    refute msg.valid?, 'Blank Mesage should be invalid'


    assert_match(/blank/, msg.errors[:email].to_s)
    assert_match(/blank/, msg.errors[:body].to_s)
  end
  
end
