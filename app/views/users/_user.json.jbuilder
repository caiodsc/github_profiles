# frozen_string_literal: true

json.extract! user, :id, :name, :github_url, :github_name, :followers, :following, :stars, :contributions_last_year,
              :profile_image_url, :created_at, :updated_at
json.url user_url(user, format: :json)
