# == Schema Information
#
# Table name: identities
#
#  id         :bigint(8)        not null, primary key
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  username   :string(255)
#  avatar_url :string(255)
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Identity < ApplicationRecord
  belongs_to :user

  def formatted_name
    Identity.formatted_name(provider)
  end

  def self.formatted_name(provider)
    case provider
    when 'google_oauth2'
      'Google'
    else
      provider.capitalize
    end
  end

  def icon
    Identity.icon(provider)
  end

  def self.icon(provider)
    case provider
    when 'google_oauth2'
      'google'
    else
      provider
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    if auth_object == :admin
      %w(username uid)
    else
      []
    end
  end
end
