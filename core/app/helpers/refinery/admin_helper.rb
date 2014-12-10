module Refinery
  module AdminHelper

    def current_admin_locale
      # TODO: move current_admin_locale to Refinery::I18n
      ::I18n.locale
    end
    
    def truncate_locale(locale)
      locale =~ /\-/ ? locale.upcase.to_s.split('-')[1] : locale.upcase
    
    end

  end
end
