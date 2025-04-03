# frozen_string_literal: true

module I18nTestHelper
  def t(key, **)
    I18n.t(key, **)
  end

  def error_message(model, attribute, type, **options)
    attr_name = model.human_attribute_name(attribute)
    msg_key = "errors.messages.#{type}"

    if options[:attribute]
      other_attr = model.human_attribute_name(options[:attribute])
      "#{attr_name} #{t(msg_key, attribute: other_attr)}"
    else
      "#{attr_name} #{t(msg_key, **options)}"
    end
  end
end
