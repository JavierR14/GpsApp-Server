class AddAuthtokenToUser < ActiveRecord::Migration
  def change
	add_column :users, :authtoken, :string
	add_column :users, :authtoken_expiry, :datetime
  end
end
