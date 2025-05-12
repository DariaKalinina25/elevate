# frozen_string_literal: true

module ElapsedFormatter
  extend ActiveSupport::Concern

  included do
    private

    def format_elapsed_time(total_seconds)
      hours   = total_seconds / 3600
      minutes = (total_seconds % 3600) / 60
      seconds = total_seconds % 60

      I18n.t('time_tracker.elapsed', h: hours, m: minutes, s: seconds)
    end
  end
end
