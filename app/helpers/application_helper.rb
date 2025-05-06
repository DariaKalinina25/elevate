# frozen_string_literal: true

# Provides helper methods for views.
module ApplicationHelper
  def current_date_str
    Date.current.strftime('%d.%m.%Y')
  end
end
