# frozen_string_literal: true

FactoryBot.define do
  factory :timer do
    user
    title { generate(:title) }
    duration_seconds { 60 }

    trait :not_expired do
      started_at { 5.seconds.ago }
      stopped_at { started_at + duration_seconds }
    end

    trait :expired do
      started_at { 1.hour.ago }
      stopped_at { started_at + duration_seconds }
    end

    trait :stopped do
      started_at { 1.hour.ago }
      stopped_at { started_at + duration_seconds }
      status { :stopped }
    end
  end
end
