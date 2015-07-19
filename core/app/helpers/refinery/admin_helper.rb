module Refinery
  module AdminHelper

    def current_admin_locale
      # TODO: move current_admin_locale to Refinery::I18n
      ::I18n.locale
    end

    def locale_country(locale)
      locale.to_s.upcase.split('-').last
    end

    def refinery_turbolinks_include_tags
      tags = []
      tags << javascript_include_tag('jquery.turbolinks') if defined?(JqueryTurbolinks)
      tags << javascript_include_tag('turbolinks') if defined?(Turbolinks)
      tags.join("\n").html_safe
    end

  end
end
