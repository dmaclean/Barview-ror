require 'test_helper'

class UserQuestionnaireAnswerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "test requiredness" do
    a = UserQuestionnaireAnswer.new
    assert a.invalid?
    
    a.user_id = 1
    assert a.invalid?
    
    a.user_questionnaire_question_id = 1
    assert a.invalid?
    
    a.user_questionnaire_option_id = 1
    assert a.valid?
  end
  
  test "insert a hash of question-answer pairs" do
    answers = {1 => ["", "8", "2"], 2 => ["", "6"]}
    a = UserQuestionnaireAnswer.new
    a.user_id = 5
    
    assert_difference("UserQuestionnaireAnswer.count", 3) do
      a.insert_user_answers(answers)
    end
    
    result = UserQuestionnaireAnswer.find(:all, :conditions => ['user_id = ? and user_questionnaire_option_id = ? and user_questionnaire_question_id = ?', a.user_id, 2, 1])
    assert result.length == 1
    
    result = UserQuestionnaireAnswer.find(:all, :conditions => ['user_id = ? and user_questionnaire_question_id = ?', a.user_id, 1])
    assert result.length == 2
    
    result = UserQuestionnaireAnswer.find(:all, :conditions => ['user_id = ? and user_questionnaire_option_id = ? and user_questionnaire_question_id = ?', a.user_id, 6, 2])
    assert result.length == 1
  end
end
