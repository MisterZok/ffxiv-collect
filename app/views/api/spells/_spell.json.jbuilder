json.(spell, :id, :name, :description, :tooltip, :order, :rank, :patch)
json.owned @owned.fetch(spell.id.to_s, '0%')
json.icon spell.image_url

json.type do
  json.(spell.type, :id, :name)
end

json.aspect do
  json.(spell.aspect, :id, :name)
end

json.partial! 'api/shared/sources', collectable: spell
