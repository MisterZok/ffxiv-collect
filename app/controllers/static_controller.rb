class StaticController < ApplicationController
  def commands
    @oauth_url = 'https://discord.com/oauth2/authorize' \
      "?client_id=#{Rails.application.credentials.dig(:discord, :interactions_client_id)}" \
      '&scope=applications.commands'
  end

  def credits
    config = Rails.application.config_for(:credits)

    @developers = Character.where(id: config.developers).sort_by { |item| config.developers.index(item.id) }
    @sourcers = Character.where(id: config.sourcers).sort_by { |item| config.sourcers.index(item.id) }
    @translators = Character.where(id: config.translators).order(:name)
    @supporters = Character.where(supporter: true).order(:name)
  end

  def faq
    @users = Redis.current.get('stats-users')
    @characters = Redis.current.get('stats-characters')
    @achievement_characters = Redis.current.get('stats-achievement-characters')
  end

  def home
    @discord_link = view_context.link_to('Discord', 'https://discord.gg/bA9fYQjEYy', target: '_blank')
  end

  def blank
    render locals: { hide_footer: true }
  end

  def not_found
    flash[:error] = t('alerts.not_found')
    redirect_to root_path
  end
end
