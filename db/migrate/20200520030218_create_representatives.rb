# frozen_string_literal: true

class CreateRepresentatives < ActiveRecord::Migration[5.2]
  def up
    create_table :representatives do |t|
      t.string :name
      t.timestamps null: false
    end
  end

  def down
    drop_table :representatives
  end
end
