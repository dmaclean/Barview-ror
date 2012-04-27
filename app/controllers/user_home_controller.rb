class UserHomeController < ApplicationController
  def index
    # Check if we're dealing with a bar.  If so, redirect them to /barhome
	if session[:bar_id]
	  redirect_to barhome_url, :flash => { :notice => "If you would like to view the main Barview page, log out first, then click the 'Users' link." }
	  return
	end
    
    # We have a logged-in user
    if session[:user_id]
      @bars = Bar.joins(:favorites).where('favorites.user_id' => session[:user_id])
      
      if @bars.empty? 
        @bars = Bar.find(:all)
        @events = get_all_events
      else
        @nonfaves = Bar.all(:limit => 5 - @bars.length, :conditions => ['id not in (select bar_id from favorites where user_id = ?)', [session[:user_id]] ])
        @nonfave_events = Bar.all(:select => 'bars.name, bar_events.detail', :joins => :bar_event)
		@events = get_events_for_favorites
        @has_favorites = true
      end
    else
      @bars = Bar.find(:all)
      @events = get_all_events
    end
  end
  
  private
  def get_events_for_favorites
    events = Hash.new
    temp = Bar.find(:all, :select => 'bars.name, bar_events.detail', :joins => :bar_event, :conditions => ['bars.id in (select bar_id from favorites where user_id = ?)', [session[:user_id]] ])
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
	temp = Bar.find(:all, :select => 'bars.name, bar_events.detail', :joins => :bar_event)
	for t in temp do
	  if events.key?(t.name)
	    events[t.name] << t.detail
	  else
	    events[t.name] = [t.detail]
	  end
	end
	
	events
  end
end
