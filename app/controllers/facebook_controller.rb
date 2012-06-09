class FacebookController < ApplicationController
  # Process Facebook login
  def create
    # generate a new oauth object with your app data and your callback url
	session['oauth'] = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_SECRET'], @base_url + '/facebook/callback')
    
    # redirect to facebook to get your code
	redirect_to session['oauth'].url_for_oauth_code()
  end

  # Process Facebook logout
  def destroy
    session['oauth'] = nil
    session['access_token'] = nil
    redirect_to_home
  end
  
  # Callback on successful Facebook login
  def callback
    logger.info("in callback - #{ session['oauth'] }")
    
    #get the access token from facebook with your code
	session['access_token'] = session['oauth'].get_access_token(params[:code])
	
	redirect_to_home
  end
end
