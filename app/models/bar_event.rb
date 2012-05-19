class BarEvent < ActiveRecord::Base
  attr_accessible :bar_id, :detail
  belongs_to :bar
  
  class << self
    def get_events_for_favorites(email)
      # select b.name as name, be.detail as detail 
      # from favorites f inner join barevents be on f.bar_id = be.bar_id inner join bars b on be.bar_id = b.bar_id 
      # where f.user_id = ?'
      return BarEvent.find(:all, :select => "bars.name as name, bar_events.detail as detail", :joins => [:bar], :conditions => ["bars.id in (select f.bar_id from favorites f inner join users u on f.user_id = u.id where u.email = ?)", email])
    end
  end
end
