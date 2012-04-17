class Barimage < ActiveRecord::Base
  attr_accessible :image
  
  belongs_to :bar
  
  def read_file
    file = File.new(self.image, 'r')
    @img_binary = file.read
    file.close
      
    @img_binary
  end
  
  private
  
end
