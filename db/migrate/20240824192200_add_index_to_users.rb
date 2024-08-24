class AddIndexToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :github_url, unique: true
  end
end
