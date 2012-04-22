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
end
