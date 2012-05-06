class SearchController < ApplicationController
  def index
    @results = Bar.find(:all, :select => 'id, name, address, city, state', :conditions => ['name like ? and verified = 1', [ '%' + params[:search] + '%' ]] )
    
    # Fetch favorites if we're logged in
    if session[:user_id]
      @favorites = Favorite.find(:all, :select => 'bar_id', :conditions => ['user_id = ?', [ session[:user_id] ]])
      @fave_hash = Hash.new
      for f in @favorites
        @fave_hash[f.bar_id] = true
      end
    end
  end
end
