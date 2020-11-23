require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @less = lessons(:one)
    @q1 = @less.questions.build(content: "puella", category: "vocab")
  end
  
  test "should be valid" do
    assert @q1.valid?
  end
  
  test "lesson id should be present" do
    @q1.lesson_id = nil
    assert_not @q1.valid?
  end
  
  test "dependent destroy should work" do
    @q1.destroy
    @less.save
    @less.questions.create!(content: "puella", category: "vocab")
    assert_difference 'Question.count', -1 do
      @less.destroy
    end
  end
  
  
  
end
