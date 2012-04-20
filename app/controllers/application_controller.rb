class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :init_vars
  
  private
  def init_vars
    @base_url = 'http://' + request.host
    if request.port != 80
      @base_url += ':' + request.port.to_s
    end
  end
end
