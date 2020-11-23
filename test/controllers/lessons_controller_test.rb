

require 'test_helper'

class LessonsControllerTest < ActionDispatch::IntegrationTest
 include Devise::Test::IntegrationHelpers
  setup do
    @lesson = lessons(:one)
  end

  test "should get index" do

    #sign_in users(:admin_user)
    get lessons_url
    assert_response :success
  end

  test "admin should get new" do
    sign_in users(:admin_user)
    get new_lesson_url
    assert_response :success
  end
  
  test "reg_user should not get new" do
    sign_in users(:reg_user)
    get new_lesson_url
    assert_redirected_to root_path
  end

  test "admin should create lesson" do
    sign_in users(:admin_user)
    assert_difference('Lesson.count') do
      post lessons_url, params: { lesson: { name: "Basics" } }
    end

    assert_redirected_to edit_lesson_url(Lesson.last)
  end
  
  test "reg_user should not create lesson" do
    sign_in users(:reg_user)
    assert_no_difference('Lesson.count') do
      post lessons_url, params: { lesson: { name: "Basics" } }
    end

    assert_redirected_to root_path
  end

  test "should show lesson" do
    sign_in users(:reg_user)
    get lesson_url(@lesson)
    assert_response :success
  end
  
  test "should not show lesson if not logged on" do
    get lesson_url(@lesson)
    assert_redirected_to root_path
  end
  
  test "should not show lesson above level" do
    sign_in users(:reg_user)
    get lesson_url(lessons(:two))
    assert_redirected_to root_path
  end

  test "admin should get edit" do
    sign_in users(:admin_user)
    get edit_lesson_url(@lesson)
    assert_response :success
  end
  
  test "reg user should not get edit" do
    sign_in users(:reg_user)
    get edit_lesson_url(@lesson)
    assert_redirected_to root_path
  end

  test "admin should update lesson" do
    sign_in users(:admin_user)
    patch lesson_url(@lesson), params: { lesson: { name: "new name" } }
    assert Lesson.find(@lesson.id).name == 'new name'
    assert_redirected_to edit_lesson_url(@lesson)
  end
  
  test "reg user should not update lesson" do
    sign_in users(:reg_user)
    patch lesson_url(@lesson), params: { lesson: { name: 'new name' } }
    assert Lesson.find(@lesson.id).name != 'new name'
    assert_redirected_to root_path
  end

  test "admin should destroy lesson" do
    sign_in users(:admin_user)
    assert_difference('Lesson.count', -1) do
      delete lesson_url(@lesson)
    end

    assert_redirected_to lessons_url
  end
  
  test "reg user should not destroy lesson" do
    sign_in users(:reg_user)
    assert_no_difference('Lesson.count') do
      delete lesson_url(@lesson)
    end

    assert_redirected_to root_path
  end
end
