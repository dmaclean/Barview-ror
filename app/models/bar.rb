class Bar < ActiveRecord::Base
  attr_accessible :address, :city, :email, :id, :lat, :lng, :name, :password, :reference, :state, :username, :verified, :zip
  validates :address, :city, :email, :lat, :lng, :name, :password, :reference, :state, :username, :zip, :presence => true
  validates :username, :uniqueness => true
  validates :zip, :format => { 
  					:with => /^\d{5}$/,
  					:message => "A zip code must consist of exactly 5 numbers (no letters)"
  }
  validates :email, :format => {
              		:with    => /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(?:[a-zA-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$/i,
              		:message => "A valid email address is required." }
end
