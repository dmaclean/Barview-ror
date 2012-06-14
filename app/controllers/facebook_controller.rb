class FacebookController < ApplicationController
  # Process Facebook login
  def create
    # generate a new oauth object with your app data and your callback url
    logger.info("Creating Koala oauth for app #{ ENV['FB_APP_ID'] }  with secret #{ ENV['FB_SECRET_KEY'] }")
	session['oauth'] = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_SECRET_KEY'], @base_url + '/facebook/callback')
    
    # redirect to facebook to get your code
	redirect_to session['oauth'].url_for_oauth_code()
  end

  # Process Facebook logout
  def destroy
    session['oauth'] = nil
    session['access_token'] = nil
    session[:usertype] = nil
    session[:user_id] = nil
    redirect_to_home
  end
  
  # Callback on successful Facebook login
  def callback
    #get the access token from facebook with your code
	#session['access_token'] = session['oauth'].get_access_token(params[:code])
	#session[:usertype] = "FACEBOOK"
	
	# Poll the graph and get the user id
	#graph = Koala::Facebook::API.new(session[:access_token])
	#userdata = graph.get_object("me")
	#logger.info("Graph data for user: #{ userdata.inspect }")
	
	#User.create_or_update_facebook_data(userdata)
	#begin
	#  fbuser = FbUser.find_by_fb_id(userdata["id"])
	#  session[:user_id] = fb
	#rescue
	#  logger.error("Unable to find facebook user #{ userdata['id'] }")
	#end
	
	user = User.new
	user.log_fb_user_in(session, params[:code])
	
	redirect_to_home
  end
end
