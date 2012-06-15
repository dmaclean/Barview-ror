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
  has_one  :fb_user, :dependent => :destroy
  
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
    #def mobile_logout(token)
    #  mobile_token = MobileToken.find_by_token(token)
    #  if mobile_token
    #    mobile_token.delete
    #  end
    #end
    
    def generate_mobile_xml(user, mobile_token)
      xml = "<id>#{ user.id }</id>"
      xml += "<firstname>#{ user.first_name }</firstname>"
      xml += "<lastname>#{ user.last_name }</lastname>"
      xml += "<gender>#{ user.gender }</gender>"
      xml += "<email>#{ user.email }</email>"
      xml += "<dob>#{ user.dob }</dob>"
      xml += "<city>#{ user.city }</city>"
      xml += "<state>#{ user.state }</state>"
      xml += "<token>#{ mobile_token.token }</token>"
      
      logger.debug("Generated mobile xml of #{ xml }")
      
      xml
    end
  end  # End of static methods
  
  def parse_fb_birthdate(birthdate)
    date_pieces = birthdate.split("/")
    "#{ date_pieces[2] }-#{ date_pieces[0] }-#{ date_pieces[1] }"
  end
  
  # 
  def create_or_update_facebook_data(fb_data)
    # Determine if the facebook user already exists in our database.
    begin
      fbuser = FbUser.find_by_fb_id(fb_data["id"])
        
      user = User.find(fbuser.user_id)
      user.first_name = fb_data["first_name"]
      user.last_name = fb_data["last_name"]
      user.gender = fb_data["gender"].capitalize
      user.email = "fb_#{ fb_data["email"] }"
      user.dob = self.parse_fb_birthdate(fb_data["birthday"])
      user.city = fb_data["location"]["name"].split(",")[0].strip
      user.state = user.get_state_abbreviation(fb_data["location"]["name"].split(",")[1].strip)
       
      # Save user
      if not user.save
        print "Could not persist new user #{ user.first_name } #{ user.last_name } with facebook id #{ fb_data[:id] }"
        user.errors.each{|attr,msg| puts "#{attr} - #{msg}" }
        logger.error("Could not persist new user #{ user.first_name } #{ user.last_name } with facebook id #{ fb_data[:id] }")
        return
      end
        
    rescue
      # We're in the rescue block, so we didn't find the user (this is a new user).
      user = User.new
      user.first_name = fb_data["first_name"]
      user.last_name = fb_data["last_name"]
      user.gender = fb_data["gender"].capitalize
      user.email = "fb_#{ fb_data["email"] }"
      user.dob = self.parse_fb_birthdate(fb_data["birthday"])
      user.city = fb_data["location"]["name"].split(",")[0].strip
      user.state = user.get_state_abbreviation(fb_data["location"]["name"].split(",")[1].strip)
      user.password = "fb_user"
        
      # Save user
      if not user.save
        print "Could not persist new user #{ user.first_name } #{ user.last_name } with facebook id #{ fb_data["id"] }"
        user.errors.each{|attr,msg| puts "#{attr} - #{msg}" }
        logger.error("Could not persist new user #{ user.first_name } #{ user.last_name } with facebook id #{ fb_data["id"] }")
        return
      end
        
      fbuser = FbUser.new
      fbuser.fb_id = fb_data["id"]
      fbuser.user_id = user.id
        
      # Save fb/user association
      if not fbuser.save
        print "Could not persist new fb user with fb id #{ fbuser.fb_id } and user id #{ fbuser.user_id }"
        fbuser.errors.each{|attr,msg| puts "#{attr} - #{msg}\n" }
        logger.error("Could not persist new fb user with fb id #{ fbuser.fb_id } and user id #{ fbuser.user_id }")
        return
      end
    end
  end
  
  def log_fb_user_in(session, token_code)
    #get the access token from facebook with your code
	session['access_token'] = session['oauth'].get_access_token(token_code)
	session[:usertype] = "FACEBOOK"
	
	# Poll the graph and get the user id
	graph = Koala::Facebook::API.new(session[:access_token])
	userdata = graph.get_object("me")
	logger.info("Graph data for user: #{ userdata.inspect }")
	
    self.create_or_update_facebook_data(userdata)
	begin
	  fbuser = FbUser.find_by_fb_id(userdata["id"])
	  session[:user_id] = fbuser.user_id
	rescue
	  logger.error("Unable to find facebook user #{ userdata['id'] }")
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
  
  def get_state_abbreviation(state)
      states = Hash.new
      states["Alabama"] = "AL"
      states["Alaska"] = "AK"
      states["Arizona"] = "AZ"
      states["Arkansas"] = "AR"
      states["California"] = "CA"
      states["Colorado"] = "CO"
      states["Connecticut"] = "CT"
      states["Delaware"] = "DE"
      states["District of Columbia"] = "DC"
      states["Florida"] = "FL"
      states["Georgia"] = "GA"
      states["Hawaii"] = "HI"
      states["Idaho"] = "ID"
      states["Illinois"] = "IL"
      states["Indiana"] = "IN"
      states["Iowa"] = "IA"
      states["Kansas"] = "KS"
      states["Kentucky"] = "KY"
      states["Louisiana"] = "LA"
      states["Maine"] = "ME"
      states["Maryland"] = "MD"
      states["Massachusetts"] = "MA"
      states["Michigan"] = "MI"
      states["Minnesota"] = "MN"
      states["Mississippi"] = "MS"
      states["Missouri"] = "MO"
      states["Montana"] = "MT"
      states["Nebraska"] = "NE"
      states["Nevada"] = "NV"
      states["New Hampshire"] = "NH"
      states["New Jersey"] = "NJ"
      states["New Mexico"] = "NM"
      states["New York"] = "NY"
      states["North Carolina"] = "NC"
      states["North Dakota"] = "ND"
      states["Ohio"] = "OH"
      states["Oklahoma"] = "OK"
      states["Oregon"] = "OR"
      states["Pennsylvania"] = "PA"
      states["Rhode Island"] = "RI"
      states["South Carolina"] = "SC"
      states["South Dakota"] = "SD"
      states["Tennessee"] = "TN"
      states["Texas"] = "TX"
      states["Utah"] = "UT"
      states["Vermont"] = "VT"
      states["Virginia"] = "VA"
      states["Washington"] = "WA"
      states["West Virginia"] = "WV"
      states["Wisconsin"] = "WI"
      states["Wyoming"] = "WY"
      
      states[state]
    end
  
  private
    def password_must_be_present
      errors.add(:password, "Missing password") unless hashed_password.present?
    end
    
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end
