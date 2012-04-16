class RemovePasswordFromBars < ActiveRecord::Migration
  def up
    remove_column :bars, :password
      end

  def down
    add_column :bars, :password, :string
  end
end
