# frozen_string_literal: true

class AddColumnsToRepresentatives < ActiveRecord::Migration[5.2]
  def change
    add_column :representatives, :ocdid, :string
    add_column :representatives, :title, :string
  end
end
