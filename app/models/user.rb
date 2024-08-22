class User < ApplicationRecord
  validates_presence_of :name, :github_url
end
