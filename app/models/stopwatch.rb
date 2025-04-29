# frozen_string_literal: true

# Model for custom stopwatches
class Stopwatch < ApplicationRecord
  include SetTitleIfBlank

  belongs_to :user

  enum :status, { started: 0, stopped: 1 }

  scope :stopped_recent, ->(limit = 3) { stopped.order(created_at: :desc).limit(limit) }

  validate :ensure_single_started, on: :create

  validates :title, length: { maximum: 10 }

  def stop
    return false if stopped?

    self.stopped_at = Time.current
    self.status = :stopped
    save
  end

  def elapsed_time_str
    return I18n.t('time.elapsed', h: 0, m: 0, s: 0) unless started_at

    total = ((stopped_at || Time.current) - started_at).to_i
    hours   = total / 3600
    minutes = (total % 3600) / 60
    seconds = total % 60

    I18n.t('time.elapsed', h: hours, m: minutes, s: seconds)
  end

  private

  def ensure_single_started
    return unless started?
    return unless user.stopwatches.started.exists?

    errors.add(:base, I18n.t('time.errors.already_running'))
  end
end
