# frozen_string_literal: true

class AddUidProviderIndexToUsers < ActiveRecord::Migration[5.2]
  def up
    # Enforce uniqueness of (uid, provider) pairs.
    add_index :users, %i[uid provider], unique: true, name: 'index_users_on_uid_provider'
  end

  def down
    remove_index :users, name: 'index_users_on_uid_provider'
  end
end
