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
  has_many :user_questionnaire_answers, :dependent => :destroy
  has_many :mobile_tokens, :dependent => :destroy
  
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
    
    ##################################################################################
    # Performs authentication for mobile users.  Here we take the password that the
    # user entered and compare it against the decrypted database password (provided
    # we get a hit on the database for the username).
    # If the comparison is successful then we package all the user information up
    # into an XML structure and send it back to the caller.
    # If the comparison fails then we simply send back an empty <user> XML aggregate.
    ##################################################################################
    def mobile_login(email, password)
      user = authenticate(email, password)
	  xml = "<user>"
   
      if user
        mobile_token = MobileToken.new
        mobile_token.user_id = user.id
        mobile_token.token = Digest::SHA2.hexdigest(user.id.to_s + Time.now().to_s)
        mobile_token.save
        
        xml += generate_mobile_xml(user, mobile_token)
      end

      xml += "</user>"
		
      xml
    end
    
    ################################################################################
    # Attempts to log out a mobile user by deleting their token from the database.
    ################################################################################
    def mobile_logout(token)
      mobile_token = MobileToken.find_by_token(token)
      if mobile_token
        mobile_token.delete
      end
    end
    
    def generate_mobile_xml(user, mobile_token)
      xml = "<firstname>#{ user.first_name }</firstname>"
      xml += "<lastname>#{ user.last_name }</lastname>"
      xml += "<gender>#{ user.gender }</gender>"
      xml += "<email>#{ user.email }</email>"
      xml += "<dob>#{ user.dob }</dob>"
      xml += "<city>#{ user.city }</city>"
      xml += "<state>#{ user.state }</state>"
      xml += "<token>#{ mobile_token.token }</token>"
      
      xml
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
  
  def reset_password
    pw = 'barviewpassword' + Time.now.to_s
    pw = self.class.encrypt_password(pw, self.salt)
    pw = pw[0,10]
    
    self.hashed_password = self.class.encrypt_password(pw, self.salt)
    if self.save
      # Send the welcome email message
      BvMailer.reset_user_password(self, pw).deliver
      
      pw
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
