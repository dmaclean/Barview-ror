require 'test_helper'

class BarimageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "save image works" do
    bar_image = Barimage.new
    bar_image[:bar_id] = 2
    bar_image[:image] = 'broadcast_images/2.jpeg'
    bar_image.save
    bar_image = Barimage.find_by_bar_id(2)
    assert bar_image[:bar_id] == 2
    assert bar_image[:image] == 'broadcast_images/2.jpeg'
  end
end
