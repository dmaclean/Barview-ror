class BarEvent < ActiveRecord::Base
  attr_accessible :bar_id, :detail
  belongs_to :bar
end
