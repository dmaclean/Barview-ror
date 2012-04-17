require 'test_helper'

class BarimageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "save image works" do
    bar_image = Barimage.new
    bar_image[:bar_id] = 1
    bar_image[:image] = 'public/broadcast_images/1.jpeg'
    bar_image.save
    bar_image = Barimage.find_by_bar_id(1)
    assert bar_image.read_file != nil
  end
end
