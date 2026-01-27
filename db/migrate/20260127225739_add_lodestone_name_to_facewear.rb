class AddLodestoneNameToFacewear < ActiveRecord::Migration[7.2]
  def change
    add_column :facewear, :lodestone_name, :string
  end
end
