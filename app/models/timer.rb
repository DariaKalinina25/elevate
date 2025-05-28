# frozen_string_literal: true

# Timer is a model for user-defined countdown timers with a fixed duration.
#
# Key features:
# - Has two statuses: :started and :stopped.
# - Each timer belongs to a user.
# - Initialized with status :started, start time (`started_at`) set to current time.
# - When stopped, updates `stopped_at` and final duration, or simply changes status if already expired.
# - Created through a transaction in the `TimerCreator` service (see its docs).
#
# Includes:
# - `SetTitleIfBlank`: see module docs — assigns current date as title if blank.
# - `ElapsedFormatter`: see module docs — formats time (in seconds) as HH:MM:SS.

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

  # The `elapsed_time_str` method returns the elapsed time as a string in HH:MM:SS format.
  # If the timer hasn't started yet, it returns 00:00:00.
  def elapsed_time_str
    return format_elapsed_time(0) unless started_at

    total = stopped_at <= Time.current ? duration_seconds : (Time.current - started_at).to_i
    format_elapsed_time(total)
  end
end
