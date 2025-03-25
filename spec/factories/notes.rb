# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    user
    title { generate(:title) }
    content { 'Text of the note' }
  end

  sequence :title do |n|
    "Note#{n}"
  end
end
