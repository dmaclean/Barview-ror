class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :init_vars
  
  ##############################################################
  # Convenience method that sends a user back to the homepage.
  ##############################################################
  def redirect_to_home
    redirect_to '/'
  end
  
  private
  def init_vars
    @base_url = 'http://' + request.host
    if request.port != 80
      @base_url += ':' + request.port.to_s
    end
    
    @is_bar_side = request.url =~ /barhome/i
    @no_hero = request.url =~ /(about|adminlogin|bars|forgot_password|mobile_info|users)/i
  end
end
