json.(field_record, :id, :name, :description, :rarity, :location, :patch, :linked_record_id)
json.owned @owned.fetch(field_record.id.to_s, '0%')
json.image field_record.large_image_url
json.icon field_record.image_url

json.partial! 'api/shared/sources', collectable: field_record
