# frozen_string_literal: true

FactoryBot.define do
  factory :stopwatch do
    user
    title { generate(:title) }

    trait :stopped do
      status { :stopped }
    end
  end
end
