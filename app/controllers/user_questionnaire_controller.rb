class UserQuestionnaireController < ApplicationController
  def index
    # This user isn't logged in so we boot them to the homepage.
    if not session[:user_id]
      logger.debug { 'User is not logged in so they cannot see the questionnaire page.' }
      redirect_to '/userhome'
      return
    end
  end

  # responds to post
  def create
    answers = Hash.new
    for k,v in params do
      if k.index('q') == 0
        answers[k.slice(1..k.size)] = v["0"]
      end
    end
    
    a = UserQuestionnaireAnswer.new
    a.user_id = session[:user_id]
    a.insert_user_answers(answers)
    
    redirect_to '/userhome'
  end
end
