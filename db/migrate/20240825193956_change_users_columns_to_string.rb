# frozen_string_literal: true

class ChangeUsersColumnsToString < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :followers, :string
    change_column :users, :following, :string
    change_column :users, :stars, :string
    change_column :users, :contributions_last_year, :string
  end
end
