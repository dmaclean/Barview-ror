class CreateUserQuestionnaireAnswers < ActiveRecord::Migration
  def change
    create_table :user_questionnaire_answers do |t|
      t.integer :user_questionnaire_question_id
      t.integer :user_id
      t.integer :user_questionnaire_option_id

      t.timestamps
    end
  end
end
