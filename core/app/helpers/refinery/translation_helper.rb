module Refinery
  module TranslationHelper

    # Overrides Rails' core I18n.t() function to produce a more helpful error message.
    # The default one wreaks havoc with CSS and makes it hard to understand the problem.
    def t(key, **options)
      if (val = super) =~ /class.+?translation_missing/
        val = val.to_s.gsub(/<span[^>]*>/, 'i18n: ').gsub('</span>', '').gsub(', ', '.')
      end

      val
    end

    def translated_field(record, field)
      Refinery::TranslatedFieldPresenter.new(record).call(field)
    end

    def locales_with_translated_field(record, field_name, include_current: true)
      field_name = field_name.to_sym
      translations = record.translations.where.not(field_name => [nil, ""])
      translations = translations.where.not(locale: current_locale) unless include_current
      translations.map { |t| t.locale.to_sym }.sort_by { |locale| Refinery::I18n.frontend_locales.index(locale) }
    end

    private def current_locale
      Refinery::I18n.current_locale.to_s
    end
  end
end
