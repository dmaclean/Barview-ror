class BarImageRequest < ActiveRecord::Base
  #attr_accessible :bar_id, :user_id
  validates :bar_id, :user_id, :presence => true
  
  belongs_to :user
  belongs_to :bar
  
  class << self
	  def get_realtime_viewers(bar_id, sec)
		# Barview users
		
		# sqlite compatible
		#results = BarImageRequest.find(:all, :select => 'distinct users.first_name as first_name, users.last_name as last_name', :joins => :user, :conditions => ["bar_image_requests.bar_id = ? and bar_image_requests.created_at > datetime('now', '-? seconds')", bar_id, sec])
		
		# PostgreSQL compatible
		results = BarImageRequest.find(:all, :select => 'distinct users.first_name as first_name, users.last_name as last_name, users.email as email', :joins => :user, :conditions => ["bar_image_requests.bar_id = ? and bar_image_requests.created_at > (current_timestamp - interval '? seconds')", bar_id, sec])
		logger.debug { results.inspect }
		
		users = ''
		for r in results do
		  if users == ''
			users += "#{ r.first_name } #{ r.last_name[0].chr } (#{ r.email })"
		  else
			users += "|#{ r.first_name } #{ r.last_name[0].chr } (#{ r.email })"
		  end
		end
		
		users
	  end
  end
end
