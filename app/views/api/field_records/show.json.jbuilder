json.cache! [@field_record, I18n.locale] do
  json.partial! 'api/field_records/field_record', field_record: @field_record, owned: @owned
end
