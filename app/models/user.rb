# frozen_string_literal: true

class User < ApplicationRecord
  include UserConstants

  validates :name, presence: true, length: { maximum: 25 }
  validates :github_url, presence: true, length: { maximum: 50 }, uniqueness: true
  encrypts :github_url, deterministic: true, downcase: true

  after_create :start_processing!

  scope :search_by_term, lambda { |term|
    query = SEARCH_COLUMNS.map { |column| "#{column} ILIKE :term" }.join(' OR ')
    where(query, term: "%#{term}%")
  }

  state_machine :state, initial: :pending do
    state PENDING_STATE
    state PROCESSING_STATE
    state COMPLETED_STATE
    state FAILED_STATE

    event :start_processing do
      transition pending: :processing
    end

    event :reprocess do
      transition all - [:pending] => :processing
    end

    after_transition to: :processing, do: :enqueue_processing_job
  end

  private

  def enqueue_processing_job
    GithubScraperJob.perform_later(id)
  end
end
