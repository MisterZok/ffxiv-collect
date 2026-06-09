json.(achievement, :id, :name, :description, :points, :order, :patch)
json.owned @owned.fetch(achievement.id.to_s, '0%')
json.icon achievement.image_url

category = achievement.category

json.category do
  json.(category, :id, :name)
end

json.type do
  json.(category.type, :id, :name)
end

unless local_assigns[:skip_reward]
  json.reward do
    if achievement.title.present?
      json.type 'Title'
      json.title do
        json.partial! 'api/titles/title', title: achievement.title, owned: @owned, skip_achievement: true
      end
    elsif achievement.item_id.present?
      json.type 'Item'
      json.name achievement.item.name
    end
  end
end
