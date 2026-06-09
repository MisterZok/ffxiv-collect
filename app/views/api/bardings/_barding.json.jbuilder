json.(barding, :id, :name, :order, :patch, :item_id)

json.tradeable barding.tradeable?
if @prices.present?
  json.market @prices[barding.item_id]
end

json.owned @owned.fetch(barding.id.to_s, '0%')
json.icon barding.image_url
json.partial! 'api/shared/sources', collectable: barding
