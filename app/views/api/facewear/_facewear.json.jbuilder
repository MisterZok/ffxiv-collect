json.(facewear, :id, :name, :order, :patch, :item_id)

json.tradeable facewear.tradeable?
if @prices.present?
  json.market @prices[facewear.item_id]
end

json.owned @owned.fetch(facewear.id.to_s, '0%')
json.icon facewear.image_url

json.partial! 'api/shared/sources', collectable: facewear
