class AddLatestIdentityIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :latest_identity_id, :integer
  end
end
