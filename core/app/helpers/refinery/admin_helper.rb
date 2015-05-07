module Refinery
  module AdminHelper

    def current_admin_locale
      # TODO: move current_admin_locale to Refinery::I18n
      ::I18n.locale
    end

    def locale_country(locale)
      locale.to_s.upcase.split('-').last
    end

  end
end
