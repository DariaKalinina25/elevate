# frozen_string_literal: true

module I18nTestHelpers
  def t(key, **)
    I18n.t(key, **)
  end

  def human_name(model, attribute)
    model.human_attribute_name(attribute)
  end

  def error_message(model, attribute, type, **options)
    attr_name = human_name(model, attribute)
    msg_key = "errors.messages.#{type}"

    if options[:attribute]
      other_attr =  human_name(model, options[:attribute])
      "#{attr_name} #{t(msg_key, attribute: other_attr)}"
    else
      "#{attr_name} #{t(msg_key, **options)}"
    end
  end
end
