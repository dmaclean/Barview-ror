class UserQuestionnaireQuestion < ActiveRecord::Base
  attr_accessible :question
  
  validates :question, :presence => true
  
  has_many :user_questionnaire_option, :dependent => :destroy
end
