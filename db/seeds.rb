# frozen_string_literal: true

require 'faker'

user = User.find_or_create_by!(email: 'demo@example.com') do |u|
  # this is a pet project with an intentionally open password
  u.password = 'password'
  u.password_confirmation = 'password'
end

5.times do
  title = [Faker::Lorem.word.truncate(10), ''].sample
  content = Faker::Lorem.paragraphs(number: 3).join("\n\n")

  user.notes.create!(
    title: title,
    content: content
  )
end
