# frozen_string_literal: true

# Parses "HH:MM:SS" duration strings to total seconds.
module DurationParser
  def self.to_seconds(duration_str)
    return 0 if duration_str.blank?

    hours, minutes, seconds = duration_str.split(':').map(&:to_i)
    (hours * 3600) + (minutes * 60) + seconds
  end
end
