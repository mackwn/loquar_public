require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @answer = answers(:one)
  end

  test "admin should get index" do
    sign_in users(:admin_user)
    get answers_url
    assert_response :success
  end
  
  test "reg user should not get index" do
    sign_in users(:reg_user)
    get answers_url
    assert_redirected_to root_path
  end

  test "admin should get new" do
    sign_in users(:admin_user)
    get new_answer_url
    assert_response :success
  end
  
  test "reg user should not get new" do
    get new_answer_url
    assert_redirected_to root_path
  end

  test "admin should create answer" do
    sign_in users(:admin_user)
    assert_difference('Answer.count') do
      post answers_url, params: { answer: { content: @answer.content, question_id: @answer.question_id } }
    end

    assert_redirected_to edit_question_url(Question.find(@answer.question_id))
  end
  
  test "reg user should not create answer" do
    sign_in users(:reg_user)
    assert_no_difference('Answer.count') do
      post answers_url, params: { answer: { content: @answer.content, question_id: @answer.question_id } }
    end

    assert_redirected_to root_path
  end

  test "admin should show answer" do
    sign_in users(:admin_user)
    get answer_url(@answer)
    assert_response :success
  end
  
  test "reg user should not show answer" do
    sign_in users(:reg_user)
    get answer_url(@answer)
    assert_redirected_to root_path
  end

  test "admin should get edit" do
    sign_in users(:admin_user)
    get edit_answer_url(@answer)
    assert_response :success
  end
  
  test "reg user should not get edit" do
    sign_in users(:reg_user)
    get edit_answer_url(@answer)
    assert_redirected_to root_path
  end
  
  test "admin should update answer" do
    sign_in users(:admin_user)
    patch answer_url(@answer), params: { answer: { content: 'new content', question_id: @answer.question_id } }
    assert Answer.find(@answer.id).content == 'new content'
    assert_redirected_to edit_question_url(Question.find(@answer.question_id))
  end
  
  test "reg user should not update answer" do
    sign_in users(:reg_user)
    patch answer_url(@answer), params: { answer: { content: @answer.content, question_id: @answer.question_id } }
    assert Answer.find(@answer.id).content != 'new content'
    assert_redirected_to root_path
  end

  test "admin should destroy answer" do
    sign_in users(:admin_user)
    assert_difference('Answer.count', -1) do
      delete answer_url(@answer)
    end

    assert_redirected_to edit_question_url(Question.find(@answer.question_id))
  end
  
  test "reg user should not destroy answer" do
    sign_in users(:reg_user)
    assert_no_difference('Answer.count') do
      delete answer_url(@answer)
    end

    assert_redirected_to root_path
  end
end
