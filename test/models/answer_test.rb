require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @quest = questions(:one)
    @a1 = @quest.answers.build(content: "puella")
  end
  
  test "should be valid" do
    assert @a1.valid?
  end
  
  test "lesson id should be present" do
    @a1.question_id = nil
    assert_not @a1.valid?
  end
  
  test "dependent destroy should work" do
    @a1.destroy
    @quest.save
    @quest.answers.create!(content: "puella")
    assert_difference 'Question.count', -1 do
      @quest.destroy
    end
  end
end
