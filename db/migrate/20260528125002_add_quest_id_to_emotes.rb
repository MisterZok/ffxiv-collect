class AddQuestIdToEmotes < ActiveRecord::Migration[7.2]
  def change
    add_column :emotes, :quest_id, :integer
  end
end
