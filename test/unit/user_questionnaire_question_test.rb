require 'test_helper'

class UserQuestionnaireQuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "requiredness" do
    q = UserQuestionnaireQuestion.new
    assert q.invalid?
    
    q.question = 'How are you?'
    assert q.valid?
  end
end
