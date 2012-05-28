require 'aws/s3'

class Barimage < ActiveRecord::Base
  attr_accessible :image, :bar_id
  
  belongs_to :bar
  
  def read_file
    s3init
    
    if AWS::S3::S3Object.exists? self.image, @bucketname
      @img_binary = AWS::S3::S3Object.value self.image, @bucketname
    else
      @img_binary = AWS::S3::S3Object.value 'barview.jpg', @bucketname
    end
    
    @img_binary
  end
  
  def write_file(data)
    s3init
    
    return AWS::S3::S3Object.store(self.image, data, @bucketname)
  end
  
  private
  def s3init
    if not AWS::S3::Base.connected?
      AWS::S3::Base.establish_connection!(
        :access_key_id     => 'AKIAJJLWIEOFCWR5T2KQ',
        :secret_access_key => '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'
      )
    end
    
    if Rails.env.development?
      @bucketname = 'barview_dev'
    elsif Rails.env.test?
      @bucketname = 'barview_test'
    elsif Rails.env.production?
      @bucketname = 'barview'
    end
  end
end
