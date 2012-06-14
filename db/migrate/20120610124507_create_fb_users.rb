class CreateFbUsers < ActiveRecord::Migration
  def change
    create_table :fb_users do |t|
      t.string :fb_id
      t.integer :user_id

      t.timestamps
    end
  end
end
