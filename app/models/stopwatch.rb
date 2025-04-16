# frozen_string_literal: true

class Stopwatch < ApplicationRecord
  include SetTitleIfBlank

  belongs_to :user

  enum :status, { started: 0, stopped: 1 }

  validates :title, length: { maximum: 10 }

  def stop
    return if stopped?

    self.stopped_at = Time.current
    self.status = :stopped
    save
  end

  def elapsed_time_str
    total = ((stopped_at || Time.current) - started_at).to_i
    Time.at(total).utc.strftime('%-Hh %-Mm %-Ss')
  end
end
