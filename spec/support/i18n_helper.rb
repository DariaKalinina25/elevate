module I18nTestHelper
  def t(key, **options)
    I18n.t(key, **options)
  end
end
