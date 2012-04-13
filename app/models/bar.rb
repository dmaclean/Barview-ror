class Bar < ActiveRecord::Base
  attr_accessible :address, :city, :email, :id, :lat, :lng, :name, :password, :reference, :state, :username, :verified, :zip
  validates :address, :city, :email, :lat, :lng, :name, :password, :reference, :state, :username, :zip, :presence => true
  validates :username, :uniqueness => true
  validates :zip, :format => { 
  					:with => /^\d{5}$/,
  					:message => "A zip code must consist of exactly 5 numbers (no letters)"
  }
  validates :email, :format => {
              		:with    => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i,
              		:message => "Only letters allowed" }
end
