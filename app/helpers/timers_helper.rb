module TimersHelper
  def timer_timer_attrs(timer)
    {
      id: 'timer-timer',
      class: 'timer-output',
      data: timer.persisted? ? {
        controller: 'timer',
        'timer-started-at-value': timer.started_at.iso8601,
        'timer-stopped-at-value': timer.stopped_at.iso8601,
        'timer-timer-id-value': timer.id,
        'timer-target': 'timer',
        testid: 'timer-field'
      } : {}
    }
  end
end
