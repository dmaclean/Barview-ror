require 'test_helper'

class BarImageRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "is valid" do
    bir = BarImageRequest.new
    assert bir.invalid?
    
    bir.user_id = 1
    assert bir.invalid?
    
    bir.bar_id = 1
    assert bir.valid?
  end
end
