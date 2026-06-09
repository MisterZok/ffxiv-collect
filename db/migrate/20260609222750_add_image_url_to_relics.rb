class AddImageUrlToRelics < ActiveRecord::Migration[7.2]
  def change
    add_column :relics, :image_url, :string
  end
end
