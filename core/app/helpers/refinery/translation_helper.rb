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

    def locales_with_titles(record, title_field, include_current: true)
      translations = record.translations.where.not(title_field, nil )
      translations = translations.where.not(locale: current_locale) unless include_current
      translations.map(&:locale).sort_by { |t| Refinery::I18n.frontend_locales.index(t.to_sym) }
    end

    def current_locale?(locale) = locale.to_sym == Refinery::I18n.current_locale
    def current_locale =  Refinery::I18n.current_locale.to_s
    def current_language = Refinery::I18n.locales[Refinery::I18n.current_locale]
    def locale_language(locale) = Refinery::I18n.locales[locale.to_sym]

    private

    def sorted_locales(locales, frontend_locales)
      locales.map(&:to_sym).sort_by { |locale| frontend_locales.index(locale) }
    end

  end
end
