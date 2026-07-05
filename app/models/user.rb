# == Schema Information
#
# Table name: users
#
#  id                 :bigint(8)        not null, primary key
#  username           :string(255)
#  discriminator      :integer
#  avatar_url         :string(255)
#  provider           :string(255)
#  uid                :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  character_id       :integer
#  admin              :boolean          default(FALSE)
#  mod                :boolean          default(FALSE)
#  database           :string(255)      default("garland"), not null
#  latest_identity_id :integer
#

class User < ApplicationRecord
  belongs_to :character, required: false
  belongs_to :latest_identity, class_name: 'Identity', foreign_key: :latest_identity_id, required: false

  has_many :decks, primary_key: :uid, foreign_key: :user_uid
  has_many :identities
  has_many :modifications, class_name: 'PaperTrail::Version', foreign_key: :whodunnit
  has_many :owned_groups, class_name: 'Group', foreign_key: :owner_id
  has_many :user_characters
  has_many :votes

  has_many :characters, through: :user_characters
  has_many :verified_characters, -> (user) { where(verified_user: user) }, through: :user_characters, source: :character

  delegate :avatar_url, to: :latest_identity, allow_nil: true
  delegate :username, to: :latest_identity, allow_nil: true

  devise :omniauthable, :timeoutable, omniauth_providers: %i(discord google_oauth2)

  def self.from_omniauth(auth, current_user = nil)
    # Clean up any special characters in the username
    username = auth.info.name.encode(Encoding.find('ASCII'), invalid: :replace, undef: :replace, replace: '')
    email = auth.info.email

    # The key to looking up the identity
    key_fields = { provider: auth.provider, uid: auth.uid }

    # Attributes that can change between logins and should be updated
    attributes = {
      username: auth.provider == 'google_oauth2' ? email : username,
      avatar_url: auth.info.image,
    }

    identity = Identity.find_by(key_fields)

    if identity.present?
      existing_user = identity.user

      attributes.merge!(user_id: current_user.id) if current_user.present?
      identity.update!(attributes)

      user = identity.user

      # If we have moved the identity to a new user, delete the old one if it has become orphaned with no identities
      if existing_user != user && existing_user.identities.empty?
        existing_user.destroy!
      end
    else
      # Attach the identity to the current user if they are signed in, otherwise make a new user
      user = current_user || User.create!
      identity = user.identities.create!(key_fields.merge(attributes))
    end

    user.update!(latest_identity_id: identity.id)

    user
  end

  def self.ransackable_associations(auth_object = nil)
    if auth_object == :admin
      %w(latest_identity)
    else
      []
    end
  end
end
