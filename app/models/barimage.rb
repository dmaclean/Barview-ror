require 'aws/s3'

class Barimage < ActiveRecord::Base
  attr_accessible :image, :bar_id
  
  belongs_to :bar
  
  # Class-level flag to determine whether
  @@primed_cache = false
  
  def read_file
    start = Time.now
    
    # Prime the cache, if necessary
    if not @@primed_cache
      prime_cache_with_default_image
      @@primed_cache = true
    end
    
    # Look at the cache first
    @img_binary = Rails.cache.fetch("bar_image_#{ self.bar_id }")
    if @img_binary
      finish = Time.now
      logger.info("Read request took #{ (finish - start) * 1000 } milliseconds using Memcache")
      
      return @img_binary
    end
    
    # Looks like we didn't find the image in the cache.  Go to S3.
    s3init
    
    if AWS::S3::S3Object.exists? self.image, @bucketname
      @img_binary = AWS::S3::S3Object.value self.image, @bucketname
    else
      @img_binary = AWS::S3::S3Object.value 'barview.jpg', @bucketname
    end
    
    finish = Time.now
    logger.info("Read request took #{ (finish - start) * 1000 } milliseconds using S3")
    
    @img_binary
  end
  
  def write_file(data)
    s3init
    
    Rails.cache.write("bar_image_#{ self.bar_id }", data)
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
  
  ###############################################################
  # Prime the cache by ensuring that the default image for bars 
  # that have not broadcasted yet is available.
  ###############################################################
  def prime_cache_with_default_image
    s3init
    
    Rails.cache.fetch("bar_image_-1") { AWS::S3::S3Object.value 'barview.jpg', @bucketname }
  end
end
