# frozen_string_literal: true

# Model for user-created notes
class Note < ApplicationRecord
  belongs_to :user
  before_validation :set_title_if_blank

  validate :notes_limit, on: :create

  validates :title, length: { maximum: 10 }
  validates :content, presence: true, length: { maximum: 2000 }

  private

  def set_title_if_blank
    return if title.present?

    self.title = Date.current.strftime('%d.%m.%Y')
  end

  def notes_limit
    return if user.notes.count < 20
  
    errors.add(:base, I18n.t('note.errors.notes_limit'))
  end
end
