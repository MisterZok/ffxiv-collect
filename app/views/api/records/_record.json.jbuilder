json.(record, :id, :name, :description, :rarity, :location, :patch, :linked_record_id)
json.owned @owned.fetch(record.id.to_s, '0%')
json.image record.large_image_url
json.icon record.image_url

json.partial! 'api/shared/sources', collectable: record
