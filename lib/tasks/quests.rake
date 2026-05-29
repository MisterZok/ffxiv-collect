namespace :quests do
  desc 'Create the quests'
  task create: :environment do
    puts 'Creating quests'

    count = Quest.count
    quests = %w(en de fr ja tc).each_with_object({}) do |locale, h|
      XIVData.sheet('Quest', locale: locale).each do |quest|
        next unless quest['Name'].present?

        # Initialize the data and process rewards on the first pass
        if locale == 'en'
          data = { id: quest['#'],
                   event: quest['FestivalEnd'] != '0',
                   emote_reward_id: quest['EmoteReward'] != '0' ? quest['EmoteReward'] : nil }

          # Apparently this is only an item if the ItemRewardType is: 1, 3, 5
          7.times do |i|
            reward_id = quest["Reward[#{i}]"]
            break if reward_id == '0'

            # We use find_by here because some item ids in the Quest file are linked to non-existing entries in Item
            Item.find_by(id: reward_id)&.update!(quest_id: quest['#'])
          end
        else
          data = h[quest['#']]
        end

        data["name_#{locale}"] = sanitize_name(quest['Name'], locale: locale)
        h[data[:id]] = data
      end
    end

    quests.values.each do |quest|
      if existing = Quest.find_by(id: quest[:id])
        existing.update!(quest) if updated?(existing, quest)
      else
        Quest.create!(quest)
      end
    end

    puts "Created #{Quest.count - count} new quests"
  end
end
