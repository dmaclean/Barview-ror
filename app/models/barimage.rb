class Barimage < ActiveRecord::Base
  attr_accessible :image
  
  belongs_to :bar
  
  def read_file
    file = File.new(self.image, 'r')
    if file.exist?
      @img_binary = file.read
      file.close
    else
      file = File.new('public/broadcast_images/barview.jpg', 'r')
      @img_binary = file.read
      file.close
    end
    
    @img_binary
  end
  
  def write_file(data)
    file = File.open('public/' + self.image, 'w')
    file.puts(data)
	file.close
  end
  
  private
  
end
