json.(survey_record, :id, :name, :description, :solution, :patch)
json.dungeon survey_record.series&.name
json.owned @owned.fetch(survey_record.id.to_s, '0%')
json.image survey_record.large_image_url
json.icon survey_record.image_url
