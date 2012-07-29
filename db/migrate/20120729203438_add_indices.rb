class AddIndices < ActiveRecord::Migration
  def up
    # Create indexes on bar_id and created_at for Bar Image Requests
    add_index :bar_image_requests, :bar_id
    add_index :bar_image_requests, :created_at
    
    # Create indexes for latitude and longitude in the Bars table to speed up proximity searches.
    add_index :bars, :lat
    add_index :bars, :lng
  end

  def down
  end
end
