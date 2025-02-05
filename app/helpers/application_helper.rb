module ApplicationHelper
  USD_TO_EUR = 0.96
  USD_TO_PO8 = 8
  def number_to_currency_for_locale(number, locale = I18n.locale)
    case locale
    when :en then number_to_currency(number, locale: locale)
    when :es then number_to_currency(number * USD_TO_EUR, locale: locale)
    when :pirate then number_to_currency(number * USD_TO_PO8, locale: locale)
    end
  end
end
