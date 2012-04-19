class CreateBarEvents < ActiveRecord::Migration
  def change
    create_table :bar_events do |t|
      t.integer :bar_id
      t.text :detail

      t.timestamps
    end
  end
end
