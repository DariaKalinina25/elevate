# frozen_string_literal: true

# Base class for all application models, providing common configurations.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
