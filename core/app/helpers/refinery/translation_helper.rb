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
  end
end
