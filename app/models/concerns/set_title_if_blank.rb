# frozen_string_literal: true

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
