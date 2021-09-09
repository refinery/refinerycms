module Refinery
  module TranslationHelper
    # Overrides Rails' core I18n.t() function to produce a more helpful error message.
    # The default one wreaks havoc with CSS and makes it hard to understand the problem.
    def t(key, options = {})
      if (val = super) =~ /class.+?translation_missing/
        val = val.to_s.gsub(/<span[^>]*>/, 'i18n: ').gsub('</span>', '').gsub(', ', '.')
      end

      val
    end

    def translated_field(record, field)
      Refinery::TranslatedFieldPresenter.new(record).call(field)
    end

    # Markup for the translation links on index pages
    def switch_locale(object, edit_path, field = :title)
      return unless Refinery::I18n.frontend_locales.many?

      path_minus_locale = remove_locale_from_path(edit_path)

      object.translations
            .sort_by { |t| Refinery::I18n.frontend_locales.index(t.locale) }
            .select  { |t| t.send(field).present? }
            .map     { |t| locale_markup(path_minus_locale, t.locale) }
            .join(' ')
    end

    private

      def locale_markup(path, locale)
        link_to locale_marker(locale.upcase), locale_edit_path(path, locale), class: [:locale, :edit], title: locale.upcase
      end

      #  just adding back the switch-locale with the new locale
      def locale_edit_path(path, locale)
        "#{path}?switch_locale=#{locale}"
      end

      def locale_marker(locale)
        tag.span locale_text_icon(locale), class: [locale, :locale_marker]
      end

      def remove_locale_from_path(edit_path)
        uri = URI.parse(edit_path)
        queries = URI.decode_www_form(uri.query || '').to_h
        uri.query = queries.except('switch-locale').presence
        uri.to_s
      end
  end
end
