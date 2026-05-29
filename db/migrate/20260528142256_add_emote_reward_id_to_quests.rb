class AddEmoteRewardIdToQuests < ActiveRecord::Migration[7.2]
  def change
    add_column :quests, :emote_reward_id, :integer
    remove_column :emotes, :quest_id
  end
end
