class DropIconId < ActiveRecord::Migration[7.2]
  def change
    remove_column :achievements, :icon_id, :string, limit: 6
    remove_column :items, :icon_id, :string, limit: 6
  end
end
