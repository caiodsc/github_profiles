# frozen_string_literal: true

class User < ApplicationRecord
  PENDING_STATE = :pending
  PROCESSING_STATE = :processing
  COMPLETED_STATE = :completed
  FAILED_STATE = :failed
  SEARCH_COLUMNS = %w[name github_name location organization].freeze

  validates_presence_of :name, :github_url
  validates_uniqueness_of :github_url

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

  def enqueue_processing_job
    GithubScraperJob.perform_later(id)
  end
end
