# == Schema Information
#
# Table name: character_field_records
#
#  id              :bigint(8)        not null, primary key
#  character_id    :integer
#  field_record_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class CharacterFieldRecord < ApplicationRecord
  belongs_to :character, counter_cache: :field_records_count, touch: true
  belongs_to :field_record
end
