require 'test_helper'

class BarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
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
      :id => 1,
      :address => '10 Juniper Lane',
      :city => 'Medfield',
      :email => 'dan@bar-view.com',
      :lat => 1.5,
      :lng => 1.5,
      :name => 'Dan Bar',
      :password => 'password',
      :reference => 'hello',
      :state => 'MA',
      :username => 'dmaclean',
      :verified => 0,
      :zip => 'abc'
    )
    
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
end
