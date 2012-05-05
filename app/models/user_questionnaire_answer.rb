class UserQuestionnaireAnswer < ActiveRecord::Base
  #attr_accessible :user_id, :user_questionnaire_option_id, :user_questionnaire_question_id
  validates :user_id, :user_questionnaire_option_id, :user_questionnaire_question_id, :presence => true
  
  def insert_user_answers(answers)
    for k,v in answers do
      a = UserQuestionnaireAnswer.new
      a.user_id = self.user_id
      a.user_questionnaire_option_id = v
      a.user_questionnaire_question_id = k
      a.save
    end
  end
end
