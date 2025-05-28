# frozen_string_literal: true

# Provides view helpers for the Timer component
module TimersHelper
  # rubocop:disable Metrics/MethodLength
  def timer_timer_attrs(timer)
    {
      id: 'timer-timer',
      class: 'timer-output',
      data: if timer.persisted?
              {
                controller: 'timer',
                'timer-started-at-value': timer.started_at.iso8601,
                'timer-stopped-at-value': timer.stopped_at.iso8601,
                'timer-timer-id-value': timer.id,
                'timer-target': 'timer',
                testid: 'timer-field'
              }
            else
              {}
            end
    }
  end
  # rubocop:enable Metrics/MethodLength
end
