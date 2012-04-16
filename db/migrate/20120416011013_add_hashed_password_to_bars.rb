class AddHashedPasswordToBars < ActiveRecord::Migration
  def change
    add_column :bars, :hashed_password, :string
  end
end
