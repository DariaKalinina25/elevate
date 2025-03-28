# frozen_string_literal: true

# User model handles authentication and user-related data.
class User < ApplicationRecord
  has_many :notes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
