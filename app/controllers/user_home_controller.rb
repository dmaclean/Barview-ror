class UserHomeController < ApplicationController
  def index
    # Check if we're dealing with a bar.  If so, redirect them to /barhome
	if session[:bar_id]
	  redirect_to barhome_url, :flash => { :notice => "If you would like to view the main Barview page, log out first, then click the 'Users' link." }
	  return
	end
    
    # We have a logged-in user
    if session[:user_id]
      user = User.find(session[:user_id])
    
      @bars = Bar.joins(:favorites).where('favorites.user_id' => session[:user_id], :verified => 1)
      
      # Determine if we should show the questionnaire for the user.  If so, then
      # grab all the questions and their associated options.
      @show_questionnaire = show_questionnaire?
      if @show_questionnaire
        @questionnaire = fetch_questionnaire
      end
      
      if @bars.empty? 
        @bars = Bar.find(:all, :conditions => ['verified = 1'])
        @events = get_all_events
      else
        @nonfaves = Bar.all(:limit => 5 - @bars.length, :conditions => ['id not in (select bar_id from favorites where user_id = ?) and verified = 1', [session[:user_id]] ])
        @nonfave_events = user.fetch_non_favorite_bar_events
		@events = get_events_for_favorites
        @has_favorites = true
      end
    else
      @bars = Bar.find(:all, :conditions => ['verified = 1'])
      @events = get_all_events
    end
  end
  
  private
  def get_events_for_favorites
    events = Hash.new
    temp = Bar.find(:all, :select => 'bars.name, bar_events.detail', :joins => :bar_event, :conditions => ['bars.id in (select bar_id from favorites where user_id = ?) and verified = 1', [session[:user_id]] ])
    for t in temp do
	  if events.key?(t.name)
	    events[t.name] << t.detail
	  else
	    events[t.name] = [t.detail]
	  end
	end
	
	events
  end
  
  def get_all_events
    events = Hash.new
	temp = Bar.find(:all, :select => 'bars.name, bar_events.detail', :joins => :bar_event, :conditions => ['verified = 1'])
	for t in temp do
	  if events.key?(t.name)
	    events[t.name] << t.detail
	  else
	    events[t.name] = [t.detail]
	  end
	end
	
	events
  end
  
  #############################################################################
  # Determine whether or not the user questionnaire should be shown based on 
  # whether the user has any answers in the database.
  #############################################################################
  def show_questionnaire?
    show = true
  
    begin
      answers = UserQuestionnaireAnswer.where(['user_id = ?', session[:user_id]])
      show = answers.empty?
    rescue => e
      logger.debug { "#{ e.class } - #{ e.message }" }
    end
    
    show
  end
  
  def fetch_questionnaire
    questions = UserQuestionnaireQuestion.find(:all, :select => 'user_questionnaire_questions.id as qid, user_questionnaire_questions.question as question, user_questionnaire_options.id as oid, user_questionnaire_options.user_questionnaire_question_id as oqid, user_questionnaire_options.answer as answer', :joins => :user_questionnaire_option)
    qhash = Hash.new
    for q in questions do
      if qhash.key?(q.qid)
        question = qhash[q.qid]
        question['options'][q.oid] = q.answer
      else
        question = Hash.new
        question['question'] = q.question
        question['options'] = Hash.new
        question['options'][q.oid] = q.answer
        qhash[q.qid] = question
      end
    end
    
    qhash
  end
end
