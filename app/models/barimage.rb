require 'aws/s3'

class Barimage < ActiveRecord::Base
  attr_accessible :image, :bar_id
  
  belongs_to :bar
  
  def read_file
    start = Time.now
    s3init
    
    if AWS::S3::S3Object.exists? self.image, @bucketname
      @img_binary = AWS::S3::S3Object.value self.image, @bucketname
    else
      @img_binary = AWS::S3::S3Object.value 'barview.jpg', @bucketname
    end
    
    finish = Time.now
    logger.info("Read request took #{ (finish - start) * 1000 } milliseconds")
    
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
        :access_key_id     => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
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
