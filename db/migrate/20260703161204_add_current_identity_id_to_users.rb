class AddCurrentIdentityIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :current_identity_id, :integer
  end
end
