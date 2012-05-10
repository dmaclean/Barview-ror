class ViewersController < ApplicationController
  def index
    seconds = request.env['HTTP_SECONDS_BACK']
    logger.debug("Looking for bar image requests up to #{ seconds } seconds in the past for bar #{ session[:bar_id] }")
    
    respond_to do |format|
      if not session[:bar_id]
        format.html { render :text => 'Invalid bar id'}
      else
        format.html { render :text => BarImageRequest.get_realtime_viewers(session[:bar_id], seconds.to_i) }
      end
    end
  end
end
