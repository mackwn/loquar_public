require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @less = lessons(:one)
  end
  
  test "should be valid" do
    assert @less.valid?
  end
  
  test "should be invalid" do
    @less.name = nil
    assert_not @less.valid?
  end
  
  
end
