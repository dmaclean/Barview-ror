require 'test_helper'

class UserQuestionnaireOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "requiredness" do
    o = UserQuestionnaireOption.new
    
    assert o.invalid?
    
    o.user_questionnaire_question_id = 1
    assert o.invalid?
    
    o.answer = 'hello'
    assert o.valid?
  end
end
