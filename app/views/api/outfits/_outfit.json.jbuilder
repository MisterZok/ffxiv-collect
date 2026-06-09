json.(outfit, :id, :name, :patch, :gender, :armoireable, :item_id)

json.tradeable outfit.tradeable?
json.owned @owned.fetch(outfit.id.to_s, '0%')
json.icon outfit.image_url

json.items outfit.items do |item|
  json.(item, :id, :name)
end

json.partial! 'api/shared/sources', collectable: outfit
