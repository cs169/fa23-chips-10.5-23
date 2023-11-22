# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe 'GET #login' do
    it 'renders the login template' do
      get :login
      expect(response).to render_template('login')
    end

    it 'redirects to the root path if already logged in' do
      session[:current_user_id] = 1
      get :login
      expect(response).to redirect_to(user_profile_path)
    end
  end

  describe 'GET #google_oauth2 or #github' do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    end

    it 'creates a new user for google_oauth2' do
      expect do
        get :google_oauth2
      end.to change(User, :count).by(1)
    end

    it 'creates a new user for github' do
      expect do
        get :github
      end.to change(User, :count).by(1)
    end

    it 'finds an existing user for google_oauth2' do
      User.create(uid: '12345', provider: 'google_oauth2')
      expect do
        get :google_oauth2
      end.not_to change(User, :count)
    end

    it 'finds an existing user for github' do
      User.create(uid: '12345', provider: 'github')
      expect do
        get :github
      end.not_to change(User, :count)
    end

    it 'redirects to the root path' do
      get :google_oauth2
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #logout' do
    it 'clears the session' do
      session[:current_user_id] = 1
      get :logout
      expect(session[:current_user_id]).to be_nil
    end

    it 'redirects to the root path' do
      get :logout
      expect(response).to redirect_to(root_path)
    end
  end
end
