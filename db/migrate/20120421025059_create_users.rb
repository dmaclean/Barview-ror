class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :hashed_password
      t.date :dob
      t.string :city
      t.string :state
      t.string :gender

      t.timestamps
    end
  end
end
