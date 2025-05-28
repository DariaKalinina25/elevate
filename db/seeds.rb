# frozen_string_literal: true

require 'faker'

user = User.find_or_create_by!(email: 'demo@example.com') do |u|
  # this is a pet project with an intentionally open password
  u.password = 'password'
  u.password_confirmation = 'password'
end

5.times do
  title = %w[Plan Topics Exams Notes Goals].sample
  content = Faker::Lorem.paragraphs(number: 3).join("\n\n")

  user.notes.create!(
    title: title,
    content: content
  )
end

5.times do
  title = %w[Study Read Plan].sample
  started_at = 3.hours.ago
  stopped_at = [started_at + 20.minutes, started_at + 2.hours].sample

  user.stopwatches.create!(
    title: title,
    started_at: started_at,
    stopped_at: stopped_at,
    status: :stopped
  )
end

5.times do |i|
  duration = (i + 1) * 10
  started_at = Time.current - duration.seconds
  stopped_at = started_at + duration

  user.timers.create!(
    title: "Timer #{i + 1}",
    started_at: started_at,
    stopped_at: stopped_at,
    duration_seconds: duration,
    status: :stopped
  )
end
