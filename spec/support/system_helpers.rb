# frozen_string_literal: true

module SystemHelpers
  def find_test(id, **)
    find("[data-testid='#{id}']", **)
  end
end
