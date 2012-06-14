require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "User attributes cannot be empty" do
    user = User.new
    user.invalid?
    user.errors[:first_name].any?
    user.errors[:last_name].any?
    user.errors[:dob].any?
    user.errors[:city].any?
    user.errors[:state].any?
    user.errors[:email].any?
    user.errors[:gender].any?
  end
  
  test "Email must be in correct format" do
    user = User.new(
      :first_name => 'Dan',
      :last_name => 'MacLean',
      :dob => '1982-10-21',
      :gender => 'Male',
      :city => 'Medfield',
      :email => 'dan',
      :state => 'MA'
    )
    user.password = 'password'
    
    user2 = User.find(1)
    assert user.invalid?
    assert_equal "A valid email address is required.", user.errors[:email].join('; ')
    
    user.email = 'dan@'
    assert user.invalid?
    assert_equal "A valid email address is required.", user.errors[:email].join('; ')
    
    user.email = '@something.com'
    assert user.invalid?
    assert_equal "A valid email address is required.", user.errors[:email].join('; ')
    
    user.email = '@something'
    assert user.invalid?
    assert_equal "A valid email address is required.", user.errors[:email].join('; ')
    
    user.email = 'dan@bar-view.com'
    assert user.valid?
  end
  
  test "DOB must be in correct format" do
    user = User.new(
      :first_name => 'Dan',
      :last_name => 'MacLean',
      :dob => '1982-10-ab',
      :gender => 'Male',
      :city => 'Medfield',
      :email => 'dan',
      :state => 'MA',
      :email => 'dan@bar-view.com'
    )
    user.password = 'password'
    
    assert user.invalid?
    assert_equal "can't be blank; The Date of Birth must in the format YYYY-MM-DD.", user.errors[:dob].join('; ')
    
    user.dob = '10-21-1982'
    assert user.invalid?
    assert_equal "can't be blank; The Date of Birth must in the format YYYY-MM-DD.", user.errors[:dob].join('; ')
    
    user.dob = '1982-10-21'
    assert user.valid?
  end
  
  test "reset password" do
    user = User.new(
      :first_name => 'Dan',
      :last_name => 'MacLean',
      :dob => '1982-10-21',
      :gender => 'Male',
      :city => 'Medfield',
      :email => 'dan',
      :state => 'MA',
      :email => 'dan@bar-view.com'
    )
    user.password = 'password'
    
    before = user.hashed_password
    user.reset_password
    assert user.hashed_password != before and not user.hashed_password.empty?
  end
  
  test "mobile login for good credentials" do
    xml = User.mobile_login('dmaclean@agencyport.com', 'secret')
    assert xml =~ /<user><id>1<\/id><firstname>MyString<\/firstname><lastname>MyString<\/lastname><gender>MyString<\/gender><email>dmaclean@agencyport.com<\/email><dob>2012-04-20<\/dob><city>MyString<\/city><state>MyString<\/state><token>.*?<\/token><\/user>/i
  end
  
  test "mobile login for bad credentials" do
    xml = User.mobile_login('dmaclean@agencyport.com', 'badpassword')
    assert_equal xml, "<user></user>"
  end
  
  test "create new facebook user" do
    # {"id"=>"668512494", "name"=>"Dan MacLean", "first_name"=>"Dan", "last_name"=>"MacLean", 
    # "link"=>"http://www.facebook.com/daniel.maclean", "username"=>"daniel.maclean", 
    # "birthday"=>"10/21/1982", "location"=>{"id"=>"113517895325215", "name"=>"Medfield, Massachusetts"}, 
    # "gender"=>"male", "email"=>"dmaclean82@gmail.com", "timezone"=>-4, "locale"=>"en_US", 
    # "verified"=>true, "updated_time"=>"2011-12-05T17:39:47+0000"}
  
    data = Hash.new
    data[:id] = "668512494"
    data[:name] = "Dan MacLean"
    data[:first_name] = "Dan"
    data[:last_name] = "MacLean"
    data[:link] = "http://www.facebook.com/daniel.maclean"
    data[:username] = "daniel.maclean"
    data[:birthday] = "10/21/1982"
    data[:location] = { :id, 113517895325215, :name, "Medfield, Massachusetts" }
    data[:gender] = "male"
    data[:email] = "dmaclean82@gmail.com"
    data[:timezone] = -4
    data[:locale] = "en_US"
    data[:verified] = true
    data[:updated_time] = "2011-12-05T17:39:47+0000"
  
    fbusercount = FbUser.count
    usercount = User.count
    
    # Make add/update call
    user = User.new
    user.create_or_update_facebook_data(data)
    
    # Check for entry in fb_users/users join table
    fbusercount2 = FbUser.count
    assert fbusercount2 > fbusercount
    
    begin
      fbuser = FbUser.find_by_fb_id(data[:id])
    rescue
      flunk "Could not find FbUser with fb_id of #{ data[:id] }"
    end
    
    # Check for data in the users table
    usercount2 = User.count
    assert usercount2 > usercount
    
    user_id = FbUser.find_by_fb_id(data[:id]).user_id
    user = User.find(user_id)
    
    assert user.city == "Medfield"
    assert user.dob == Date.parse("1982-10-21")
    assert user.email == "fb_dmaclean82@gmail.com"
    assert user.first_name == "Dan"
    assert user.last_name == "MacLean"
    assert user.gender == "Male"
    assert user.state == "MA"
  end
  
  test "update existing facebook user" do
    # {"id"=>"668512494", "name"=>"Dan MacLean", "first_name"=>"Dan", "last_name"=>"MacLean", 
    # "link"=>"http://www.facebook.com/daniel.maclean", "username"=>"daniel.maclean", 
    # "birthday"=>"10/21/1982", "location"=>{"id"=>"113517895325215", "name"=>"Medfield, Massachusetts"}, 
    # "gender"=>"male", "email"=>"dmaclean82@gmail.com", "timezone"=>-4, "locale"=>"en_US", 
    # "verified"=>true, "updated_time"=>"2011-12-05T17:39:47+0000"}
    
    # Create original
    data = Hash.new
    data[:id] = "5"
    data[:name] = "Dan MacLean"
    data[:first_name] = "Dan"
    data[:last_name] = "MacLean"
    data[:link] = "http://www.facebook.com/daniel.maclean"
    data[:username] = "daniel.maclean"
    data[:birthday] = "10/21/1982"
    data[:location] = { :id, 113517895325215, :name, "Medfield, Massachusetts" }
    data[:gender] = "male"
    data[:email] = "dmaclean82@gmail.com"
    data[:timezone] = -4
    data[:locale] = "en_US"
    data[:verified] = true
    data[:updated_time] = "2011-12-05T17:39:47+0000"
    
    # Make add/update call
    user = User.new
    user.create_or_update_facebook_data(data)
  
    # Update
    data = Hash.new
    data[:id] = "5"
    data[:name] = "Danno Mac"
    data[:first_name] = "Danno"
    data[:last_name] = "Mac"
    data[:link] = "http://www.facebook.com/daniel.maclean"
    data[:username] = "daniel.maclean"
    data[:birthday] = "08/22/1983"
    data[:location] = { :id, 113517895325215, :name, "Nashville, Tennessee" }
    data[:gender] = "female"
    data[:email] = "dmaclean82@gmail.com"
    data[:timezone] = -4
    data[:locale] = "en_US"
    data[:verified] = true
    data[:updated_time] = "2011-12-05T17:39:47+0000"
  
    fbusercount = FbUser.count
    usercount = User.count
    
    # Make add/update call
    user.create_or_update_facebook_data(data)
    
    # Check for entry in fb_users/users join table
    fbusercount2 = FbUser.count
    assert fbusercount2 == fbusercount
    
    begin
      fbuser = FbUser.find_by_fb_id(data[:id])
    rescue
      flunk "Could not find FbUser with fb_id of #{ data[:id] }"
    end
    
    # Check for data in the users table
    usercount2 = User.count
    assert usercount2 == usercount
    
    user_id = FbUser.find_by_fb_id(data[:id]).user_id
    user = User.find(user_id)
    
    assert user.city == "Nashville"
    assert user.dob == Date.parse("1983-08-22")
    assert user.email == "fb_dmaclean82@gmail.com"
    assert user.first_name == "Danno"
    assert user.last_name == "Mac"
    assert user.gender == "Female"
    assert user.state == "TN"
  end
end
