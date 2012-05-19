require 'test_helper'

class BarEventTest < ActiveSupport::TestCase
  test "get_events_for_user - bad user" do
    result = BarEvent.get_events_for_favorites("nonexistent@user.com")
    
    assert result.length == 0
  end
  
  test "get_events_for_user - good user" do
    result = BarEvent.get_events_for_favorites("dmaclean@agencyport.com")
    
    assert result.length == 1
    assert result[0].name == "MyString"
    assert result[0].detail = "MyText"
  end
end
