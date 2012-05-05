class CreateUserQuestionnaireOptions < ActiveRecord::Migration
  def change
    create_table :user_questionnaire_options do |t|
      t.integer :user_questionnaire_question_id
      t.text :answer

      t.timestamps
    end
  end
end
