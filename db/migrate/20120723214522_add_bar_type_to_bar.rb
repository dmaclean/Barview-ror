class AddBarTypeToBar < ActiveRecord::Migration
  def change
    add_column :bars, :bar_type, :string
  end
end
