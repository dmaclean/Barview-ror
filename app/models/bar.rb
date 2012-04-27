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
        if bar.hashed_password == encrypt_password(password, bar.salt)
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
  
  private
    def password_must_be_present
      errors.add(:password, "Missing password") unless hashed_password.present?
    end
    
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end
