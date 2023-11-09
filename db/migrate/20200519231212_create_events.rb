# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[5.2]
  def up
    create_table :events do |t|
      t.string :name, null: false
      t.text :description
      t.belongs_to :county, index: true, null: false # Where the event will take place
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps null: false
    end
  end

  def down
    drop_table :events
  end
end
