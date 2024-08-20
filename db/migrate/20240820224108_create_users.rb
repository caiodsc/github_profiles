class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :github_address
      t.string :github_name
      t.integer :followers
      t.integer :following
      t.integer :stars
      t.integer :contributions_last_year
      t.string :profile_image_url

      t.timestamps
    end
  end
end
