class UserQuestionnaireOption < ActiveRecord::Base
  attr_accessible :answer, :user_questionnaire_question_id
  
  validates :answer, :user_questionnaire_question_id, :presence => true
  
  belongs_to :user_questionnaire_question
end
