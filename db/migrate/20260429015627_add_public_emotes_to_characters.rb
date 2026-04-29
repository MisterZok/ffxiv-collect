class AddPublicEmotesToCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :characters, :public_emotes, :boolean, default: false
  end
end
