class CreateUserQuestionnaireQuestions < ActiveRecord::Migration
  def change
    create_table :user_questionnaire_questions do |t|
      t.text :question

      t.timestamps
    end
  end
end
