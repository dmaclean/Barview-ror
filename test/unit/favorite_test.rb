require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  test "get favorites by email" do
    xml = Favorite.generate_xml_for_favorites(1)
    assert xml == "<favorites><favorite><bar_id>1</bar_id><address>MyString</address><name>MyString</name></favorite><favorite><bar_id>2</bar_id><address>MyString2</address><name>MyString</name></favorite></favorites>"
  end
end
