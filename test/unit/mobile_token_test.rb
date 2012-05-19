require 'test_helper'

class MobileTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "is token valid - true" do
    result = MobileToken.is_token_valid("dmaclean@agencyport.com", "token1")
    assert result == true
  end
  
  test "is token valid - false - bad token" do
    assert MobileToken.is_token_valid("dmaclean@agencyport.com", "badtoken") == false
  end
  
  test "is token valid - false - bad id" do
    assert MobileToken.is_token_valid("dmaclean@bademail.com", "token1") == false
  end
  
  test "is token valid - false - nil token" do
    assert MobileToken.is_token_valid("dmaclean@bademail.com", nil) == false
  end
  
  test "is token valid - false - nil id" do
    assert MobileToken.is_token_valid(nil, "token1") == false
  end
end
