json.(fashion, :id, :name, :description, :order, :patch, :item_id)

json.tradeable fashion.tradeable?
if @prices.present?
  json.market @prices[fashion.item_id]
end

json.owned @owned.fetch(fashion.id.to_s, '0%')
json.image fashion.large_image_url
json.icon fashion.image_url

json.partial! 'api/shared/sources', collectable: fashion
