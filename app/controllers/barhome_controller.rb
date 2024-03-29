class BarhomeController < ApplicationController
  def index
    @logged_in = session[:bar_id] != nil
    #@r = Random.new
    
    # User is logged in
    if @logged_in
      @bar = Bar.find(session[:bar_id])
      @events = BarEvent.find_all_by_bar_id(session[:bar_id])
    end
  end
end
