class UserQuestionnaireAnswer < ActiveRecord::Base
  validates :user_id, :user_questionnaire_option_id, :user_questionnaire_question_id, :presence => true
  
  # Iterate through each one of the selected question options and store it as an
  # answer in the database.
  def insert_user_answers(answers)
    for k,v in answers do
      for val in v do
        if val == ""
          next
        end
        a = UserQuestionnaireAnswer.new
        a.user_id = self.user_id
        a.user_questionnaire_option_id = val
        a.user_questionnaire_question_id = k
        a.save
      end
    end
  end
end
