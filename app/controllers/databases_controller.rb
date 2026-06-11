class DatabasesController < ApplicationController
  def link
    type = params[:type]
    id = params[:id]

    case current_user&.database
    when 'teamcraft'
      locale = I18n.locale == :tc ? :tw : I18n.locale
      url = "https://ffxivteamcraft.com/db/#{locale}/#{type}/#{id}"
    else
      url = "https://www.garlandtools.org/db/##{type}/#{id}"
    end

    redirect_to url, allow_other_host: true
  end
end
