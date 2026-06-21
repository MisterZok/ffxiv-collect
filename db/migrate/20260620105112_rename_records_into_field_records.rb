class RenameRecordsIntoFieldRecords < ActiveRecord::Migration[7.2]
  def change
    rename_column :characters, :records_count, :field_records_count

    rename_table :character_records, :character_field_records
    rename_column :character_field_records, :record_id, :field_record_id

    rename_table :records, :field_records
  end
end
