class User < ApplicationRecord
  validates_presence_of :name, :github_address
end
