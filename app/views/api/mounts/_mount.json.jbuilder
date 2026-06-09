json.(mount, :id, :name, :description, :enhanced_description, :tooltip, :movement,
      :seats, :custom_music, :order, :order_group, :patch, :item_id)

json.tradeable mount.tradeable?
if @prices.present?
  json.market @prices[mount.item_id]
end

json.owned @owned.fetch(mount.id.to_s, '0%')
json.image mount.large_image_url
json.icon mount.image_url

json.partial! 'api/shared/sources', collectable: mount
