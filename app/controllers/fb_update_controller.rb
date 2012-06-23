class FbUpdateController < ApplicationController
  def create
  
    logger.info("JSON request contains #{ params[:json] }")
    parsed_json = ActiveSupport::JSON.decode(params[:json])
    logger.info("Name #{parsed_json['birthday']}")
    
    user = User.new
    user.create_or_update_facebook_data(parsed_json)
    
    render :text => "OK"
  end
end
