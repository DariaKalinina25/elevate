# frozen_string_literal: true

module I18nTestHelper
  def t(key, **)
    I18n.t(key, **)
  end

  def error_message(model, attribute, type)
    attr_name = model.human_attribute_name(attribute)
    message = I18n.t("errors.messages.#{type}")
    "#{attr_name} #{message}"
  end
end
