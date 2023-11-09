# frozen_string_literal: true

def omniauth_google_mock
  {
    provider: 'google_oauth2',
    uid:      '100000000000000000000',
    info:     {
      name:       'Google Test Developer',
      email:      'google_test@example.com',
      first_name: 'Google',
      last_name:  'Test Developer'
    }
  }
end

def omniauth_github_mock
  {
    uid:  '12345',
    info: {
      name:     'Github Test Developer',
      nickname: 'example',
      email:    'github_test@example.com'
    }
  }
end

def setup_omniauth_mocks
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(
    :google_oauth2,
    omniauth_google_mock
  )
  OmniAuth.config.add_mock(
    :github,
    omniauth_github_mock
  )
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  setup_omniauth_mocks unless Rails.env.production?

  provider :google_oauth2, Rails.application.credentials[:GOOGLE_CLIENT_ID],
           Rails.application.credentials[:GOOGLE_CLIENT_SECRET],
           {
             scope:              'userinfo.email, userinfo.profile',
             prompt:             'select_account',
             image_aspect_ratio: 'square',
             image_size:         50
           }

  provider :github, Rails.application.credentials[:GITHUB_CLIENT_ID],
           Rails.application.credentials[:GITHUB_CLIENT_SECRET]
end
