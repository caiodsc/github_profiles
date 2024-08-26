# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_826_160_501) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'github_url'
    t.string 'github_name'
    t.string 'followers'
    t.string 'following'
    t.string 'stars'
    t.string 'contributions_last_year'
    t.string 'profile_image_url'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'state', default: 'pending'
    t.string 'location'
    t.string 'organization'
    t.virtual 'unique_identifier', type: :bigint, as: "((('1'::text || lpad(((id)::character varying)::text, 5, '0'::text)) || '0'::text))::bigint", stored: true
    t.index ['github_url'], name: 'index_users_on_github_url', unique: true
    t.index ['unique_identifier'], name: 'index_users_on_unique_identifier', unique: true
  end
end
