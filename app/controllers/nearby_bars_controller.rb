#
# NEARBY BARS
#
# The REST interface for servicing nearby bar requests will satisfy the following needs:
#
# - GET requests for a list of all bars within X miles of a given set of latitude/longitude coordinates.
# 
# This interface will not respond to any POST, PUT or DELETE requests.
#
class NearbyBarsController < ApplicationController
  def index
    # Get user_id from header
	lat = request.env['HTTP_LATITUDE']
	lng = request.env['HTTP_LONGITUDE']
	lat_low = lat.to_f - 0.025
	lat_high = lat.to_f + 0.025
	lng_low = lng.to_f - 0.025
	lng_high = lng.to_f + 0.025
	print lat_low
	
	logger.debug { "Attempting to find bars in the proximity of #{ lat }/#{ lng }" }
	
	xml = '<?xml version="1.0" encoding="UTF-8" ?><nearbybars>';

	bars = Bar.where(["lat <= ? and lat >= ? and lng <= ? and lng >= ?", lat_high, lat_low, lng_high, lng_low])

    for b in bars do
      xml += "<bar>"
      xml += "<bar_id>#{ b.id }</bar_id>"
      xml += "<name>#{ b.name }</name>"
      xml += "<address>#{ b.address }</address>"
      xml += "<lat>#{ b.lat }</lat>"
      xml += "<lng>#{ b.lng }</lng>"
      xml += "</bar>"
    end

	xml += '</nearbybars>';
	print xml
	
	respond_to do |format|
	  format.html { render :text => xml }
	  format.xml { render :text => xml }
	end
  end
end
