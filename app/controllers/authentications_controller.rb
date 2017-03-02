class AuthenticationsController < ApplicationController
  skip_before_filter :require_login, only: [:create, :failure]
  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if authentication && !current_user
      # Sign in from login page. check if account active
      if authentication.user.active
        flash[:success] = 'Signed in successfully.'
        sign_in_and_redirect(authentication.user)
      else
        redirect_to login_path, flash: { danger: 'Your account is not active' }
      end

    elsif current_user && !authentication
      # Add google auth when someone already signed in
      current_user.authentications.create(provider: omniauth['provider'], uid: omniauth['uid'])
      redirect_to my_settings_path, success: 'Authentication successful.'

    elsif current_user && authentication
      # Came from my settings to add auth, but it's already used by someone else
      redirect_to my_settings_path, flash: { danger: "The Google account you've chosen is already in use." }

    elsif matching_user = User.active.find_by_email(omniauth['info']['email'])
      # Bind to account with matching email (but only if it's active)
      matching_user.authentications.create(provider: omniauth['provider'], uid: omniauth['uid'])
      sign_in_and_redirect(matching_user)

    else
      # All binding attempts failed
      redirect_to login_path, flash: { danger: 'User not found.' }
    end
  end

  # Handle negative response from Google OAuth
  def failure
    redirect_to :back, flash: { danger: 'Not authorized.' }
  end

  def destroy
    @auth = current_user.authentications.find params[:authentication_id]
    @auth.destroy

    redirect_to :back, success: 'Authentication deleted.'
  end

  private

  def sign_in_and_redirect(user)
    unless current_user
      user_session = UserSession.new(user)
      user_session.save
    end
    redirect_to home_path
  end
end
