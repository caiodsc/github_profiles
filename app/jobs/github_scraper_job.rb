# frozen_string_literal: true

class GithubScraperJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    @user = User.find(user_id)

    @user.update!(user_info)
  end

  def user_info
    GithubScraper.new(@user.github_url).user_info.merge(state: User::COMPLETED_STATE)
  rescue StandardError
    { state: User::FAILED_STATE }
  end
end
