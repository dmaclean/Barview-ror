class BarImageRequest < ActiveRecord::Base
  #attr_accessible :bar_id, :user_id
  validates :bar_id, :user_id, :presence => true
  
  belongs_to :user
  belongs_to :bar
end
