# frozen_string_literal: true

# Timer model for user countdown timers.
#
# Features:
# - Statuses: :started or :stopped.
# - Belongs to a user.
# - On creation: status is :started, `started_at` is set to current time.
# - On stop: either just updates status, or sets `stopped_at` and updates status/duration.
# Returns elapsed time as HH:MM:SS, or 00:00:00 if not started.
#
# Includes:
# - SetTitleIfBlank: sets title to current date if blank.
# - ElapsedFormatter: formats elapsed time as HH:MM:SS.
class Timer < ApplicationRecord
  include SetTitleIfBlank
  include ElapsedFormatter

  belongs_to :user

  enum :status, { started: 0, stopped: 1 }

  scope :stopped_recent, ->(limit = 3) { stopped.order(created_at: :desc).limit(limit) }

  validates :title, length: { maximum: 10 }

  validates :duration_seconds,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Stops the timer:
  # - if the timer has already expired, simply updates the status to :stopped;
  # - otherwise, sets the stop time.
  # Returns false if the timer was already stopped.
  def stop
    return false if stopped?
    return update(status: :stopped) if started? && stopped_at <= Time.current

    self.stopped_at = Time.current
    self.duration_seconds = (stopped_at - started_at).to_i
    self.status = :stopped
    save
  end

  def elapsed_time_str
    return format_elapsed_time(0) unless started_at

    total = stopped_at <= Time.current ? duration_seconds : (Time.current - started_at).to_i
    format_elapsed_time(total)
  end
end
