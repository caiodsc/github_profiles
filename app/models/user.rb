# frozen_string_literal: true

class User < ApplicationRecord
  validates_presence_of :name, :github_url
  validates_uniqueness_of :github_url

  after_create :start_processing, :enqueue_processing_job

  PENDING_STATE = :pending
  PROCESSING_STATE = :processing
  COMPLETED_STATE = :completed
  FAILED_STATE = :failed

  state_machine :state, initial: :pending do
    state PENDING_STATE
    state PROCESSING_STATE
    state COMPLETED_STATE
    state FAILED_STATE

    event :start_processing do
      transition pending: :processing
    end
  end

  def enqueue_processing_job
    GithubScraperJob.perform_later(id)
  end
end
