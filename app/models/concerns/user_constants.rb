# frozen_string_literal: true

module UserConstants
  PENDING_STATE = :pending
  PROCESSING_STATE = :processing
  COMPLETED_STATE = :completed
  FAILED_STATE = :failed
  SEARCH_COLUMNS = %w[name github_name location organization].freeze
end
