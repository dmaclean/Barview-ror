class AddBarWebsiteToBar < ActiveRecord::Migration
  def change
    add_column :bars, :bar_website, :string
  end
end
