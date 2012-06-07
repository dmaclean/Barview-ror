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
    # We don't care about Facebook for bar users.
    if not session[:bar_id]
      oauth = Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_SECRET_KEY"])
      info = oauth.get_user_info_from_cookies(cookies)
      
      # info isn't nil, looks like the FB user is signed in.
      if info
        session[:access_token] = info["access_token"]
        flash[:notice] = "Facebook user access token is #{ session[:access_token] }"
        logger.debug( "Facebook user access token is ${ session[:access_token] }" )
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
