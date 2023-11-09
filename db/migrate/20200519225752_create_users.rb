# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.integer :provider, null: false # Authentication provider eg. Google or Twitter
      t.string :uid, null: false
      t.string :email
      t.string :first_name
      t.string :last_name
      t.timestamps null: false
    end
  end

  def down
    drop_table :users
  end
end
