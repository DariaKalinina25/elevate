# frozen_string_literal: true

# Service object for safely creating a timer.
# Finishes an expired active timer (if any),
# checks that no other active timers remain,
# then creates a new timer with the given duration inside a transaction.
#
# Example:
#   TimerCreator.new(user: current_user, duration_seconds: 1500).call
class TimerCreator
  def initialize(user:, duration_seconds:, title: nil)
    @user = user
    @duration_seconds = duration_seconds
    @title = title
  end

  def call
    Timer.transaction do
      finalize_expired_timer!

      raise ActiveRecord::Rollback if @user.timers.started.exists?

      timer = @user.timers.create!(
        duration_seconds: @duration_seconds,
        title: @title
      )

      timer.update!(stopped_at: timer.started_at + @duration_seconds)

      timer
    end
  end

  private

  def finalize_expired_timer!
    expired = @user.timers.started.where(stopped_at: ..Time.current).first
    expired&.update!(status: :stopped)
  end
end
