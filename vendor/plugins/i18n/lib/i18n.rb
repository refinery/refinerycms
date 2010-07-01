class Refinery::I18n
  class << self

    attr_accessor :enabled, :current_locale, :locales, :default_locale

    def enabled?
      # cache this lookup as it gets very expensive.
      if defined?(@enabled) && !@enabled.nil?
        @enabled
      else
        @enabled = RefinerySetting.find_or_set(:refinery_i18n_enabled, false, {
          :callback_proc_as_string => %q{::Refinery::I18n.setup!}
        })
      end
    end

    def current_locale
      unless enabled?
        @current_locale = :en
        RefinerySetting[:refinery_i18n_current_locale] = :en
      else
        @current_locale ||= RefinerySetting.find_or_set(:refinery_i18n_current_locale, I18n.default_locale)

      end
    end

    def current_locale=(locale)
      @current_locale = locale.to_sym
      RefinerySetting[:refinery_i18n_current_locale] = locale.to_sym
      ::I18n.locale = locale.to_sym
    end

    def locales
      @locales ||= RefinerySetting.find_or_set(:refinery_i18n_locales, {:en => 'English',
                                                                        :fr => 'Fran&ccedil;ais',
                                                                        :nl => 'Nederlands',
                                                                        :'pt-BR' => 'Portugu&ecirc;s',
                                                                        :da => 'Dansk',
                                                                        :nb => 'Norsk Bokm&aring;l',
                                                                        :sl => 'Slovenian',
                                                                        :es => 'Espa&ntilde;ol',
                                                                        :it => 'Italiano'},
      {
        :callback_proc_as_string => %q{::Refinery::I18n.setup!}
      })
    end

    def has_locale?(locale)
      locales.has_key? locale.try(:to_sym)
    end

    def setup!
      # Re-initialize variables.
      @enabled = nil
      @locales = nil

      self.load_base_locales!
      self.load_refinery_locales!
      self.load_app_locales!
      self.set_default_locale!

      # Mislav trick to fallback to default for missing translations
      I18n.exception_handler = lambda do |e, locale, key, options|
        if I18n::MissingTranslationData === e and locale != I18n.default_locale
          I18n.translate(key, (options || {}).update(:locale => I18n.default_locale, :raise => true))
        else
          raise e
        end
      end if Rails.env.production?
    end

    def load_base_locales!
      load_locales Pathname.new(__FILE__).parent.join "..", "config", "locales", "*.yml"
    end

    def load_refinery_locales!
      load_locales Refinery.root.join "vendor", "engines", "*", "config", "locales", "*.yml"
    end

    def load_app_locales!
      load_locales Rails.root.join "config", "locales", "*.yml"
    end

    def set_default_locale!
      I18n.default_locale = @default_locale ||= RefinerySetting.find_or_set(:refinery_i18n_default_locale, :en, {
        :callback_proc_as_string => %q{::Refinery::I18n.setup!}
      })
    end

    def load_locales(locale_files)
      locale_files = locale_files.to_s if locale_files.is_a? Pathname
      locale_files = Dir[locale_files] if locale_files.is_a? String
      locale_files.each do |locale_file|
        I18n.load_path.unshift locale_file
      end
    end

  end
end

if RefinerySetting.table_exists?
  Refinery::I18n.setup!
end
