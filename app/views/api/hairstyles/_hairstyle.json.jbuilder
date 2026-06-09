json.(hairstyle, :id, :name, :description, :patch, :item_id)

json.tradeable hairstyle.tradeable?
if @prices.present?
  json.market @prices[hairstyle.item_id]
end

json.owned @owned.fetch(hairstyle.id.to_s, '0%')
json.icon hairstyle.image_url
json.partial! 'api/shared/sources', collectable: hairstyle
