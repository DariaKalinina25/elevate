# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end
end
