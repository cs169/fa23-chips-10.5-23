# frozen_string_literal: true

class CreateCounties < ActiveRecord::Migration[5.2]
  def up
    create_table :counties do |t|
      t.string :name, unique: true, null: false
      t.belongs_to :state, index: true, null: false, references: :states
      t.integer :fips_code, unique: true, limit: 2, null: false # Smallint column
      t.string :fips_class, limit: 2, null: false # Varchar(2)
      t.timestamps null: false
    end
  end

  def down
    drop_table :counties
  end
end
