# frozen_string_literal: true

# Stopwatch model for tracking user-controlled timers.
#
# Features:
# - Statuses: :started or :stopped.
# - Belongs to a user.
# - On creation: status is :started, `started_at` is set to current time.
# - On stop: sets `stopped_at` to current time and updates status.
# - Prevents creation if the user already has an active stopwatch.
# - Returns elapsed time as HH:MM:SS, or 00:00:00 if not started.
#
# Includes:
# - SetTitleIfBlank: sets title to current date if blank.
# - ElapsedFormatter: formats elapsed time as HH:MM:SS.
class Stopwatch < ApplicationRecord
  include SetTitleIfBlank
  include ElapsedFormatter

  belongs_to :user

  enum :status, { started: 0, stopped: 1 }

  scope :stopped_recent, ->(limit = 3) { stopped.order(created_at: :desc).limit(limit) }

  before_create :abort_if_user_has_active_stopwatch

  validates :title, length: { maximum: 10 }

  def stop
    return false if stopped?

    self.stopped_at = Time.current
    self.status = :stopped
    save
  end

  def elapsed_time_str
    return format_elapsed_time(0) unless started_at

    total = ((stopped_at || Time.current) - started_at).to_i
    format_elapsed_time(total)
  end

  private

  def abort_if_user_has_active_stopwatch
    return unless started?
    return unless user.stopwatches.started.exists?

    throw(:abort)
  end
end
