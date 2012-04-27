class CreateBarImageRequests < ActiveRecord::Migration
  def change
    create_table :bar_image_requests do |t|
      t.integer :bar_id
      t.integer :user_id

      t.timestamps
    end
  end
end
