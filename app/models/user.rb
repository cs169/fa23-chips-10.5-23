# frozen_string_literal: true

class User < ApplicationRecord
  # Add more Authentication Providers here.
  enum provider: { google_oauth2: 1, github: 2 }, _prefix: :provider

  # Each (uid, provider) pair should be unique.
  validates :uid, uniqueness: { scope: :provider }

  def name
    "#{first_name} #{last_name}"
  end

  def auth_provider
    {
      'google_oauth2' => 'Google',
      'github'        => 'Github'
    }[provider]
  end

  def self.find_google_user(uid)
    User.find_by(
      provider: User.providers[:google_oauth2],
      uid:      uid
    )
  end

  def self.find_github_user(uid)
    User.find_by(
      provider: User.providers[:github],
      uid:      uid
    )
  end
end
