class BarEvent < ActiveRecord::Base
  attr_accessible :bar_id, :detail
  belongs_to :bar
  
  class << self
    def get_events_for_favorites(id)
      return BarEvent.find(:all, :select => "bars.name as name, bar_events.detail as detail", :joins => [:bar], :conditions => ["bars.id in (select f.bar_id from favorites f inner join users u on f.user_id = u.id where u.id = ?)", id])
    end
    
    def get_xml_for_favorites(id)
      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><events>"
      events = BarEvent.find(:all, :select => "bars.name as name, bar_events.detail as detail", :joins => [:bar], :conditions => ["bars.id in (select f.bar_id from favorites f inner join users u on f.user_id = u.id where u.id = ?)", id])
      for e in events do
        xml += "<event><bar>#{ e.name }</bar><detail>#{ e.detail }</detail></event>"
      end
      
      xml += "</events>"
      
      xml
    end
  end
end
