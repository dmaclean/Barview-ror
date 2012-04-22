require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessible :city, :dob, :email, :first_name, :gender, :last_name, :state
  validates :city, :dob, :email, :first_name, :gender, :last_name, :state, :presence => true
  validates :password, :confirmation => true
  validates :email, :uniqueness => true

  validates :email, :format => {
              		:with    => /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(?:[a-zA-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$/i,
              		:message => "A valid email address is required." }
  
  validates :dob, :format => {
  					:with => /^\d{4}-\d{1,2}-\d{1,2}$/,
  					:message => "The Date of Birth must in the format YYYY-MM-DD."
  }
  
  attr_accessor :password_confirmation
  attr_reader   :password
  
  has_many :favorites, :dependent => :destroy
  
  validate :password_must_be_present
  
  class << self
    def authenticate(email, password)
      if user = find_by_email(email)
        if user.hashed_password == encrypt_password(password, user.salt)
          user
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
