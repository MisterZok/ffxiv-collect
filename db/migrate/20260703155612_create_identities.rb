class CreateIdentities < ActiveRecord::Migration[7.2]
  def change
    create_table :identities do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :username
      t.string :avatar_url
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :identities, :user_id
    add_index :identities, [:provider, :uid], unique: true
  end
end
