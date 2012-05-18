class Favorite < ActiveRecord::Base
  attr_accessible :bar_id, :user_id
  
  belongs_to :user
  belongs_to :bar
  
  class << self
    def generate_xml_for_favorites(email)
      favorites = Favorite.find(:all, :select => "bars.id as id, bars.address as address, bars.name as name", :joins => [:user, :bar], :conditions => ["users.email = ?", email])
      
      xml = "<favorites>"
      for f in favorites do
        xml += "<favorite>"
        xml += "<bar_id>#{ f.id }</bar_id>"
        xml += "<address>#{ f.address }</address>"
        xml += "<name>#{ f.name }</name>"
        xml += "</favorite>"
      end
      xml += "</favorites>"
      
      xml
    end
  end
end
