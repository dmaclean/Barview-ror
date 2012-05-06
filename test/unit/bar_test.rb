require 'test_helper'

class BarTest < ActiveSupport::TestCase
 
  test "Bar attributes cannot be empty" do
    bar = Bar.new
    assert bar.invalid?
    assert bar.errors[:address].any?
    assert bar.errors[:city].any?
    assert bar.errors[:email].any?
    assert bar.errors[:lat].any?
    assert bar.errors[:lng].any?
    assert bar.errors[:password].any?
    assert bar.errors[:reference].any?
    assert bar.errors[:state].any?
    assert bar.errors[:username].any?
    assert bar.errors[:zip].any?
  end
  
  test "Zip code must be 5 digits" do
    bar = Bar.new(
      :address => '10 Juniper Lane',
      :city => 'Medfield',
      :email => 'dan@bar-view.com',
      :lat => 1.5,
      :lng => 1.5,
      :name => 'Dan Bar',
      :reference => 'hello',
      :state => 'MA',
      :username => 'dmaclean',
      :verified => 0,
      :zip => 'abc'
    )
    bar.password = 'password'
    bar.build_barimage
    assert bar.barimage != nil
    
    # Should be invalid with 'abc' zip code
    assert bar.invalid?
    assert_equal "A zip code must consist of exactly 5 numbers (no letters)", 
    		bar.errors[:zip].join('; ')
    
    # 6 digits - should fail
    bar.zip = '123456'
    assert bar.invalid?
    assert_equal "A zip code must consist of exactly 5 numbers (no letters)", 
    		bar.errors[:zip].join('; ')
    
    # 5 digits - should pass
    bar.zip = '12345'
    assert bar.valid?
  end
  
  test "Email must be in correct format" do
    bar = Bar.new(
      :address => '10 Juniper Lane',
      :city => 'Medfield',
      :email => 'dan',
      :lat => 1.5,
      :lng => 1.5,
      :name => 'Dan Bar',
      :reference => 'hello',
      :state => 'MA',
      :username => 'dmaclean',
      :verified => 0,
      :zip => '12345'
    )
    bar.password = 'password'
    
    bar2 = Bar.find(1)
    assert bar.invalid?
    assert_equal "A valid email address is required.", bar.errors[:email].join('; ')
    
    bar.email = 'dan@'
    assert bar.invalid?
    assert_equal "A valid email address is required.", bar.errors[:email].join('; ')
    
    bar.email = '@something.com'
    assert bar.invalid?
    assert_equal "A valid email address is required.", bar.errors[:email].join('; ')
    
    bar.email = '@something'
    assert bar.invalid?
    assert_equal "A valid email address is required.", bar.errors[:email].join('; ')
    
    bar.email = 'dan@bar-view.com'
    assert bar.valid?
  end
  
  test "get coordinates for juniper lane" do
    bar = Bar.new(
      :address => '10 Juniper Lane',
      :city => 'Medfield',
      :state => 'MA',
      :email => 'dan@bar-view.com',
      :name => 'Dan Bar',
      :reference => 'hello',
      :username => 'dmaclean',
      :verified => 0,
      :zip => 'abc'
    )
    
    bar.fetch_coordinates
    
    assert bar.lat == 42.1709272
    assert bar.lng == -71.3008238
  end
end
