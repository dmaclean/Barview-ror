require 'test_helper'

class BarimageTest < ActiveSupport::TestCase
  test "save image works" do
    bar_image = Barimage.new
    bar_image.id = 3
    bar_image.bar_id = 3
    bar_image.image = '3.jpg'
    
    flunk( "Image was not saved correctly" ) unless bar_image.save
    
    bar_image = Barimage.find_by_bar_id(3)
    assert bar_image.bar_id == 3
    assert bar_image.image == '3.jpg'
  end
  
  test "read image binary" do
    bar_image = Barimage.find_by_bar_id(2)
    binary = bar_image.read_file
    assert binary != nil and binary != ''
  end
  
  test "read image binary for non-existent image" do
    bar_image = Barimage.find_by_bar_id(1)
    binary = bar_image.read_file
    assert binary != nil and binary != ''
  end
  
  test "write image binary" do
    bar_image = Barimage.new
    bar_image.bar_id = 3
    bar_image.image = '3.jpg'
    binary = open('public/broadcast_images/barview.jpg','r').read
    flunk("writing file to S3 failed") unless bar_image.write_file(binary)
    binary = bar_image.read_file
    assert binary != nil and binary != ''
  end
end
