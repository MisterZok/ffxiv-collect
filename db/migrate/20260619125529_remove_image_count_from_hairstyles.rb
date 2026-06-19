class RemoveImageCountFromHairstyles < ActiveRecord::Migration[7.2]
  def change
    remove_column :hairstyles, :image_count, :integer, default: 0
  end
end
