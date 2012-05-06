require 'digest/sha2'

class Bar < ActiveRecord::Base
  attr_accessible :address, :city, :email, :lat, :lng, :name, :reference, :state, :username, :verified, :zip
  validates :address, :city, :email, :lat, :lng, :name, :reference, :state, :username, :zip, :presence => true
  validates :password, :confirmation => true
  validates :username, :uniqueness => true
  validates :zip, :format => { 
  					:with => /^\d{5}$/,
  					:message => "A zip code must consist of exactly 5 numbers (no letters)"
  }
  validates :email, :format => {
              		:with    => /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(?:[a-zA-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$/i,
              		:message => "A valid email address is required." }
  
  attr_accessor :password_confirmation
  attr_reader   :password
  
  has_one :barimage, :dependent => :destroy
  has_many :bar_event, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  
  validate :password_must_be_present
  
  class << self
    def authenticate(name, password)
      if bar = find_by_username(name)
        if bar.hashed_password == encrypt_password(password, bar.salt) and bar.verified == 1
          bar
        end
      end
    end
    
    def encrypt_password(password, salt)
      Digest::SHA2.hexdigest(password + "wibble" + salt)
    end
  end
  
  # password is a virtual attribute
  def password=(password)
    @password = password
      
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  def fetch_coordinates
    host = 'maps.googleapis.com'
    reverseCodingUrl = '/maps/api/geocode/xml?address=' +
    				self.address.gsub(" ", "+") + ',' + 
					self.city.gsub(" ", "+") + ',' +
					self.state + '&sensor=false'
	
	coords = [0.0, 0.0]
	
	http = Net::HTTP.new(host)
	headers, body = http.get(reverseCodingUrl)
	if headers.code == "200"
	  if /<location>\s*<lat>([-0-9\.]*)<\/lat>\s*<lng>([-0-9\.]*)<\/lng>\s*<\/location>/i =~ body
	    data = Regexp.last_match
	    self.lat = data[1].to_f
	    self.lng = data[2].to_f
	  end
	else
	  logger.debug { "Error while fetching coordinates for #{ self.address } #{ self.city }, #{ self.state }" }
	end
  end
  
  private
    def password_must_be_present
      errors.add(:password, "Missing password") unless hashed_password.present?
    end
    
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end
