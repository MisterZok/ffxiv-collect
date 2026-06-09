json.(relic, :id, :name, :order, :achievement_id)
json.icon relic.image_url
json.owned @owned.fetch(relic.id.to_s, '0%')

json.type do
  json.(relic.type, :name, :category, :jobs, :order, :expansion)
end
