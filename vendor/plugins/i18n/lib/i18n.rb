class Refinery::I18n
  class << self

    def locales
      {:en => "English"}
    end

    def has_locale? locale
      locales.has_key? locale.try(:to_sym)
    end

    def enabled?
      false
    end

    def setup!
      self.load_base_locales!
      self.load_refinery_locales!
      self.load_app_locales!
      self.set_default_locale!
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
      I18n.default_locale = {:en => "English"}
    end

    def load_locales locale_files
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
