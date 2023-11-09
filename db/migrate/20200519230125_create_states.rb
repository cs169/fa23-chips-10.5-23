# frozen_string_literal: true

class CreateStates < ActiveRecord::Migration[5.2]
  def up
    create_table :states do |t|
      t.string :name, unique: true, null: false # eg. California
      t.string :symbol, unique: true, null: false # eg. CA
      t.integer :fips_code, unique: true, limit: 1, null: false # Tinyint column
      t.integer :is_territory, null: false
      t.float :lat_min, null: false  # Most westerly lat for state
      t.float :lat_max, null: false  # Most easterly lat for state
      t.float :long_min, null: false # Most southerly long for state
      t.float :long_max, null: false # Most northerly long for state
      t.timestamps null: false
    end
  end

  def down
    drop_table :states
  end
end
