class CreateBars < ActiveRecord::Migration
  def change
    create_table :bars do |t|
      #t.integer :id
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.float :lat
      t.float :lng
      t.string :username
      t.string :hashed_password
      t.string :salt
      t.string :email
      t.text :reference
      t.integer :verified

      t.timestamps
    end
  end
end
