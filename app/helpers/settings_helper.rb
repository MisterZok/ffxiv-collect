module SettingsHelper
  def database_options(selected = nil)
    options_for_select([['Garland Tools', 'garland'], ['FFXIV Teamcraft', 'teamcraft']], selected)
  end

  def data_center_options(character)
    options_for_select(Character.data_centers, character.pricing_data_center)
  end

  def provider_name(provider)
    fab_icon(Identity.icon(provider), text: Identity.formatted_name(provider))
  end

  def identity_status(identities, provider)
    identity = identities[provider]

    if identity.present?
      fa_icon('check-circle', text: identity.username)
    else
      # TODO: this needs a different redirect path + logic so we can add it to the current user instead of signing in
      button_to t('connect'), omniauth_authorize_path(User, provider), class: "btn btn-secondary btn-sm"
    end
  end

  def unlink_identity_button(identities, provider)
    if identities[provider].present?
      can_delete = identities.size > 1

      link_to(fa_icon('trash', text: t('delete')), unlink_identity_path(provider: provider),
        method: :delete, class: "btn btn-danger btn-sm#{ ' disabled' unless can_delete}")
    end
  end
end
