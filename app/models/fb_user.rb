class FbUser < ActiveRecord::Base
  attr_accessible :fb_id, :user_id
  
  belongs_to :user
end
