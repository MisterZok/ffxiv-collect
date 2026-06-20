json.query @query
json.count @field_records.length
json.results do
  json.cache! [@field_records, I18n.locale] do
    json.partial! 'api/field_records/field_record', collection: @field_records, as: :field_record
  end
end
