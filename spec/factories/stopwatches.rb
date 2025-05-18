# frozen_string_literal: true

FactoryBot.define do
  factory :stopwatch do
    user
    title { generate(:title) }
    started_at { Time.current }

    trait :stopped do
      status { :stopped }
      stopped_at { 5.minutes.from_now }
    end
  end
end
