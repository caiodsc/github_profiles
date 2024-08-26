# frozen_string_literal: true

module UsersHelper
  def shortened_github_url(user)
    Rails.application.config.url + "/s/#{ShortCode.encode(user.unique_identifier)}"
  end
end
