class FbUpdateController < ApplicationController
  def create
    parsed_json = ActiveSupport::JSON.decode(params[:json])
    
    user = User.new
    user.create_or_update_facebook_data(parsed_json)
    
    # A call to this service only comes from a newly logged in FB user.  So this is a good
    # spot to register their user id with the session.
    fbuser = FbUser.find_by_fb_id(parsed_json["id"])
    session[:user_id] = fbuser.user_id
    
    render :text => "OK"
  end
end
