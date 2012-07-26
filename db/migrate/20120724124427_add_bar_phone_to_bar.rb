class AddBarPhoneToBar < ActiveRecord::Migration
  def change
    add_column :bars, :bar_phone, :string
  end
end
