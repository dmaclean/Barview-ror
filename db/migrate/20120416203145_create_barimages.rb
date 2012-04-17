class CreateBarimages < ActiveRecord::Migration
  def change
    create_table :barimages do |t|
      t.integer :bar_id
      t.string :image

      t.timestamps
    end
  end
end
