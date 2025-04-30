# frozen_string_literal: true

module StopwatchesHelper
  def stopwatch_timer_attrs(stopwatch)
    {
      id: 'stopwatch-timer',
      data: {
        controller: 'stopwatch',
        'stopwatch-started-at-value': stopwatch.started_at&.iso8601,
        'stopwatch-stopped-value': stopwatch.stopped?,
        'stopwatch-target': 'timer',
        testid: 'stopwatch-field'
      }
    }
  end
end
