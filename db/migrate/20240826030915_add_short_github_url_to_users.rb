# frozen_string_literal: true

class AddShortGithubUrlToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :short_github_url, :string
  end
end
