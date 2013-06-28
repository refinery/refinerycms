module Refinery
  module LocaleHelper
    def frontend_locales
      Refinery::I18n.frontend_locales.select do |locale|
        Refinery::I18n.locales.keys.include?(locale)
      end
    end
  end
end
