FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@example.com" }
    password { 'password_example' }
    password_confirmation { 'password_example' }
  end
end
