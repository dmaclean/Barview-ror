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
  
  test "fetch two bar image requests" do
    viewers = BarImageRequest.get_realtime_viewers(1, 2)
    
    assert viewers != ''
  end
  
  test "fetch zero bar image requests" do
    viewers = BarImageRequest.get_realtime_viewers(2, 2)
    
    assert viewers == ''
  end
end
