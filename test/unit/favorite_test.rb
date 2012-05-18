require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "get favorites by email" do
    xml = Favorite.generate_xml_for_favorites("dmaclean@agencyport.com")
    assert xml == "<favorites><favorite><bar_id>1</bar_id><address>MyString</address><name>MyString</name></favorite></favorites>"
  end
end
