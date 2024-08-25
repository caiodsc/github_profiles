# frozen_string_literal: true

class AddLocationAndOrganizationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :location, :string
    add_column :users, :organization, :string
  end
end
