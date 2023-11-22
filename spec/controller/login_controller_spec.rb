# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe 'GET #login' do
    it 'renders the login template'
    it 'redirects to the root path if already logged in'
  end

  describe 'GET #google_oauth2 or #github' do
    it 'creates a new user'
    it 'finds an existing user'
    it 'redirects to the root path'
  end

  describe 'GET #logout' do
    it 'clears the session'
    it 'redirects to the root path'
  end
end
