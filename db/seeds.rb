# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
admin = Admin.new
admin.name = 'admin'
admin.password = 'getatme'
admin.save

###########################
# Questionnaire questions
###########################
q1 = UserQuestionnaireQuestion.new
q1.question = "Why do you typically go out to the bar?"
q1.save

q2 = UserQuestionnaireQuestion.new
q2.question = "What is your favorite type of drink?"
q2.save

##################################
# Questionnaire question options
##################################
hangout_q = UserQuestionnaireOption.new
hangout_q.user_questionnaire_question_id = q1.id
hangout_q.answer = "To hang out with friends"
hangout_q.save

club_q = UserQuestionnaireOption.new
club_q.user_questionnaire_question_id = q1.id
club_q.answer = "To go clubbing"
club_q.save

sport_q = UserQuestionnaireOption.new
sport_q.user_questionnaire_question_id = q1.id
sport_q.answer = "To watch sports"
sport_q.save

self_q = UserQuestionnaireOption.new
self_q.user_questionnaire_question_id = q1.id
self_q.answer = "To be by myself"
self_q.save

beer_q = UserQuestionnaireOption.new
beer_q.user_questionnaire_question_id = q2.id
beer_q.answer = "Beer"
beer_q.save

shots_q = UserQuestionnaireOption.new
shots_q.user_questionnaire_question_id = q2.id
shots_q.answer = "Shots"
shots_q.save

mixed_q = UserQuestionnaireOption.new
mixed_q.user_questionnaire_question_id = q2.id
mixed_q.answer = "Mixed drinks"
mixed_q.save

wine_q = UserQuestionnaireOption.new
wine_q.user_questionnaire_question_id = q2.id
wine_q.answer = "Wine"
wine_q.save