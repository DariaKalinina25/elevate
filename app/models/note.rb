# frozen_string_literal: true

# Model for user-created notes
class Note < ApplicationRecord
  belongs_to :user
  before_validation :set_title_if_blank

  validates :title, length: { maximum: 10 }
  validates :content, presence: true, length: { maximum: 2000 }

  def set_title_if_blank
    return if title.present?

    self.title = Date.current.strftime('%d.%m.%Y')
  end
end
