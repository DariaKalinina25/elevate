# frozen_string_literal: true

# User model handles authentication and user-related data.
class User < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :stopwatches, dependent: :destroy
  has_many :timers, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
