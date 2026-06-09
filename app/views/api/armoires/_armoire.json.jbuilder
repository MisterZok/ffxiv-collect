json.(armoire, :id, :name, :order_group, :order, :patch)
json.owned @owned.fetch(armoire.id.to_s, '0%')
json.icon armoire.image_url

json.category do
  json.(armoire.category, :id, :name)
end

json.partial! 'api/shared/sources', collectable: armoire
