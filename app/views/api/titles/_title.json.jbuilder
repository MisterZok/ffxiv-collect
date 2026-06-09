json.(title, :id, :name, :female_name, :order)
json.patch title.achievement.patch
json.owned @owned.fetch(title.achievement_id.to_s, '0%')
json.icon title.achievement.image_url

unless local_assigns[:skip_achievement]
  json.achievement do
    json.partial! 'api/achievements/achievement', achievement: title.achievement, owned: @owned, skip_reward: true
  end
end
