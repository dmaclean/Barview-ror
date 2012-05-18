class CreateMobileTokens < ActiveRecord::Migration
  def change
    create_table :mobile_tokens do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
  end
end
