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

  private
  def handle_callback
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in(@user)

    if !@user.character.present? && cookies[:character].present?
      @user.update(character_id: cookies[:character])
      @user.characters << Character.find_by(id: cookies[:character]) unless @user.characters.exists?(cookies[:character])
    end

    if @user.character.present?
      return redirect_to character_path(@user.character)
    end

    redirect_to root_path
  end
end
