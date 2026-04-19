class AddOutfitableToArmoires < ActiveRecord::Migration[7.2]
  def change
    add_column :armoires, :outfitable, :boolean, default: false
  end
end
