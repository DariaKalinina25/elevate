module I18nTestHelper
  def t(key, **options)
    I18n.t(key, **options)
  end

  def error_message(model, attribute, type)
    attr_name = model.human_attribute_name(attribute)
    message = I18n.t("errors.messages.#{type}")
    "#{attr_name} #{message}"
  end
end
