# frozen_string_literal: true

class LoginController < ApplicationController
  before_action :already_logged_in, except: [:logout]

  def login; end

  def google_oauth2
    create_session(:create_google_user)
  end

  def github
    create_session(:create_github_user)
  end

  def logout
    session[:current_user_id] = nil
    redirect_to root_path, notice: 'You have successfully logged out.'
  end

  private

  def create_session(create_if_not_exists)
    user_info = request.env['omniauth.auth']
    user = find_or_create_user(user_info, create_if_not_exists)
    session[:current_user_id] = user.id
    destination_url = session[:destination_after_login] || root_url
    session[:destination_after_login] = nil
    redirect_to destination_url
  end

  def find_or_create_user(user_info, create_if_not_exists)
    provider_sym = user_info['provider'].to_sym
    user = User.find_by(
      provider: User.providers[provider_sym],
      uid:      user_info['uid']
    )
    return user unless user.nil?

    send(create_if_not_exists, user_info)
  end

  def create_google_user(user_info)
    User.create(
      uid:        user_info['uid'],
      provider:   User.providers[:google_oauth2],
      first_name: user_info['info']['first_name'],
      last_name:  user_info['info']['last_name'],
      email:      user_info['info']['email']
    )
  end

  def create_github_user(user_info)
    # Unfortunately, Github doesn't provide first_name, last_name as separate entries.
    name = user_info['info']['name']
    if name.nil?
      first_name = 'Anon'
      last_name = 'User'
    else
      first_name, last_name = user_info['info']['name'].strip.split(/\s+/, 2)
    end
    User.create(
      uid:        user_info['uid'],
      provider:   User.providers[:github],
      first_name: first_name,
      last_name:  last_name,
      email:      user_info['info']['email']
    )
  end

  def already_logged_in
    redirect_to user_profile_path, notice: 'You are already logged in. Logout to switch accounts.' \
        if session[:current_user_id].present?
  end
end
