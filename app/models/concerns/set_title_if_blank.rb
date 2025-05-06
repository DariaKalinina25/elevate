# frozen_string_literal: true

# Automatically sets today's date as title if title is blank.
module SetTitleIfBlank
  extend ActiveSupport::Concern

  included do
    before_validation :set_title_if_blank
  end

  private

  def set_title_if_blank
    return if title.present?

    self.title = Date.current.strftime('%d.%m.%Y')
  end
end
