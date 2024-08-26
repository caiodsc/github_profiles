# frozen_string_literal: true

class AddUniqueIdentifierToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :unique_identifier, :bigint, as: "('1' || LPAD(id::varchar, 5, '0') || '0')::bigint",
                                             stored: true

    add_index :users, :unique_identifier, unique: true
  end

  def down
    remove_column :users, :unique_identifier, :bigint
  end
end
