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
    assert xml =~ /<user><firstname>MyString<\/firstname><lastname>MyString<\/lastname><gender>MyString<\/gender><email>dmaclean@agencyport.com<\/email><dob>2012-04-20<\/dob><city>MyString<\/city><state>MyString<\/state><token>.*?<\/token><\/user>/i
  end
  
  test "mobile login for bad credentials" do
    xml = User.mobile_login('dmaclean@agencyport.com', 'badpassword')
    assert_equal xml, "<user></user>"
  end
  
  test "mobile logout for good user" do
    assert_difference('MobileToken.count', -1) do
      User.mobile_logout('token1')
    end
  end
  
  test "mobile logout for invalid user" do
    assert_difference('MobileToken.count', 0) do
      User.mobile_logout('badtoken')
    end
  end
end
