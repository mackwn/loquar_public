require 'test_helper'

class FeedbackMsgsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  test "GET new when admin" do
    sign_in users(:admin_user)
    get new_feedback_msg_url

    assert_response :success

    assert_select 'form' do 

      assert_select 'input[type=email]'
      assert_select 'textarea'
      assert_select 'input[type=submit]'
    end
  end
  
  test "POST create when signed in" do
   sign_in users(:reg_user)
   post create_feedback_msg_url, params: {feedback_msg: { email: 'test@test.com', body: 'Salve!'}}

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post create_feedback_msg_url, params: {
        feedback_msg: {
          email: 'cornholio@example.org',
          body: 'hai'
        }
      }
    end
    
    assert_redirected_to new_feedback_msg_url

    follow_redirect!

    #assert_match( /Message received, thanks!/, response.body)
  end
  
  test "invalid POST create even when signed in" do
    sign_in users(:reg_user)
    post create_feedback_msg_url, params: {
      feedback_msg: {  email: '', body: '' }
    }


    assert_match(/Email .* blank/, response.body)
    assert_match(/Body .* blank/, response.body)
  end
  
end
