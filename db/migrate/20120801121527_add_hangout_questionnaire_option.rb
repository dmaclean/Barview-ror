class AddHangoutQuestionnaireOption < ActiveRecord::Migration
  def up
    q1 = UserQuestionnaireQuestion.find_by_question("Why do you typically go out to the bar?")
  
    hangout_q = UserQuestionnaireOption.new
    hangout_q.user_questionnaire_question_id = q1.id
    hangout_q.answer = "To hang out with friends"
    hangout_q.save
  end

  def down
  end
end
