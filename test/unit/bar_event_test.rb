require 'test_helper'

class BarEventTest < ActiveSupport::TestCase
  test "get_events_for_user - bad user" do
    result = BarEvent.get_events_for_favorites(999)
    
    assert result.length == 0
  end
  
  test "get_events_for_user - good user" do
    result = BarEvent.get_events_for_favorites(1)
    
    assert result.length == 2
    assert result[0].name == "MyString"
    assert result[0].detail = "MyText"
    assert result[1].name == "MyString"
    assert result[1].detail = "MyText2"
  end
  
  test "get_xml_for_favorites - good user" do
    result = BarEvent.get_xml_for_favorites(1)
    
    assert result == "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><events><event><bar>MyString</bar><detail>MyText2</detail></event><event><bar>MyString</bar><detail>MyText</detail></event></events>"
  end
  
  test "get_xml_for_favorites - bad user" do
    result = BarEvent.get_xml_for_favorites(999)
    
    assert result == "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><events></events>"
  end
end
