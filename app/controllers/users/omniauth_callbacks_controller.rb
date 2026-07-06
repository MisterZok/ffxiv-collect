class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def discord
    handle_callback
  end

  def failure
    redirect_to root_path
  end

  def google_oauth2
    handle_callback
  end

  def xivauth
    handle_callback
  end

  private
  def handle_callback
    @user = User.from_omniauth(request.env['omniauth.auth'], current_user)

    if user_signed_in?
      return redirect_to settings_path
    else
      sign_in(@user)

      # Update the user's current character and character list with the character saved to their cookies if present
      if !@user.character.present? && cookies[:character].present?
        @user.update(character_id: cookies[:character])
        @user.characters << Character.find_by(id: cookies[:character]) unless @user.characters.exists?(cookies[:character])
      end

      # Use the user's selected character profile as their landing page if available
      if @user.character.present?
        return redirect_to character_path(@user.character)
      end
    end

    redirect_to root_path
  end
end
