class AddSaltToBars < ActiveRecord::Migration
  def change
    add_column :bars, :salt, :string
  end
end
