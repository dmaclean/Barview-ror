class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_before_filter :verify_authenticity_token, :if =>lambda{ request.env["HTTP_NON_GET_TOKEN"] == "true" }
  
  before_filter :init_vars, :parse_fb_tokens
  
  ##############################################################
  # Convenience method that sends a user back to the homepage.
  ##############################################################
  def redirect_to_home
    redirect_to '/'
  end
  
  private
  def parse_fb_tokens
    # We don't care about Facebook for bar users, or if we've already processed the
    # access token for a non-bar user.
    if not session[:bar_id]
      oauth = Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_SECRET_KEY"])
      info = oauth.get_user_info_from_cookies(cookies)
      logger.info("Koala info: #{ info.inspect }")
      
      # info isn't nil so it looks like the FB user is signed in.  Let's grab their
      # access token and user_id and store them in the session.
      if info
        session[:user_id] = info["user_id"]
        session[:access_token] = info["access_token"]
        session[:usertype] = "FACEBOOK"
        logger.info( "Found Facebook user with access token #{ session[:access_token] } and user_id #{ session[:user_id] }" )

      # If there is no user info from the Facebook SDK but we already have an
      # access token and user_id in session then the cookies have expired.  
      # Let's invalidate the session.
      elsif not info and session[:access_token] and session[:user_id]
        logger.info( "Invalidating session for Facebook user with access token #{ session[:access_token] } and user_id #{ session[:user_id] }" )
        session[:user_id] = nil
        session[:access_token] = nil
        session[:usertype] = nil
      end
    end
  end
  
  #############################################################################
  # Provides an opportunity to initialize some helpful site-global variables.
  #############################################################################
  def init_vars
    @base_url = 'http://' + request.host
    if request.port != 80
      @base_url += ':' + request.port.to_s
    end
    
    @is_bar_side = request.url =~ /barhome/i
    @no_hero = request.url =~ /(about|adminlogin|bars|forgot_password|mobile_info|users)/i
  end
end
