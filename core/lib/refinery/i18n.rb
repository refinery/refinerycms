# This is replaced by refinerycms-i18n when present.
module Refinery
  module I18n
    class << self
      def enabled?
        false
      end

      def default_locale
        :en
      end

      def default_frontend_locale
        :en
      end

      def frontend_locales
        [:en]
      end
    end
  end
end
