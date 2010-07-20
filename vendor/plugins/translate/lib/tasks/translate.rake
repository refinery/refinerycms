require 'yaml'

class Hash
  def deep_merge(other)
    # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
    merger = proc { |key, v1, v2| (Hash === v1 && Hash === v2) ? v1.merge(v2, &merger) : v2 }
    merge(other, &merger)
  end

  def set(keys, value)
    key = keys.shift
    if keys.empty?
      self[key] = value
    else
      self[key] ||= {}
      self[key].set keys, value
    end
  end

  if ENV['SORT']
    # copy of ruby's to_yaml method, prepending sort.
    # before each so we get an ordered yaml file
    def to_yaml( opts = {} )
      YAML::quick_emit( self, opts ) do |out|
        out.map( taguri, to_yaml_style ) do |map|
          sort.each do |k, v| #<- Adding sort.
            map.add( k, v )
          end
        end
      end
    end
  end
end

namespace :translate do

  def find_missing_translations(locale)
    keys        = []
    result      = []
    locale_hash = {}

    puts "Searching for missing translations for the locale: #{locale}"
    default_locale_files = Dir.glob(Rails.root.join('vendor', 'plugins', '*', 'config', 'locales', "#{locale}.yml"))
    default_locale_files += Dir.glob(File.join(Translate.locales_dir, "**","#{locale}.yml"))

    default_locale_files.each do |locale_file_name|
      yaml = YAML::load(File.open(locale_file_name))
      locale_hash = locale_hash.deep_merge(yaml[locale.to_s])
    end

    lookup_pattern = /\b(?:I18n\.t|I18n\.translate|t)(?:\s|\():?'([a-z0-9_]*.[a-z0-9_.]+)'\)?/
    (Dir.glob(File.join("app", "**","*.{erb,rb}")) + Dir.glob(File.join("vendor", "plugins", "**", "app", "**", "*.{erb,rb}"))).each do |file_name|
      File.open(file_name, "r+").each do |line|
        line.scan(lookup_pattern) do |key_string|
          # qualify the namespace if beginning with . like t('.log_out')
          if key_string.first =~ /^\./
            namespace = file_name.gsub(/vendor\/plugins\/.+?\//, "").gsub(/^app\/(models|views|controllers|helpers)\//, '').split('/')
            namespace = namespace | [namespace.pop.gsub(/^\_/, '').split('.').first]
            key_string = ["#{namespace.join('.')}#{key_string.first}"]
          end
          
          unless key_exist?(key_string.first.split("."), locale_hash)
            result << "#{key_string} in \t  #{file_name} \t is not in any #{locale} locale file"
          end
        end
      end unless file_name =~ /translate\/spec/
    end
    puts result.empty? ? "No missing translations for locale: #{locale}" : "#{result.join("\n")}\n\nNumber of missing translations for #{locale}: #{result.length}"
  end

  desc "Show I18n keys that are missing in the specified locale YAML file. Defaults to I18n.default_locale, unless LOCALE env is specified"
  task :lost_in_translation => :environment do
    locale      = ENV['LOCALE'] || I18n.default_locale
    find_missing_translations(locale)
  end

  desc "Show I18n keys that are missing in all locale YAML files."
  task :lost_in_translation_all => :environment do
    ::Refinery::I18n.locales.keys.each do |locale|
      find_missing_translations(locale)
      puts "--"
    end
  end

  def key_exist?(key_arr, locale_hash)
    key = key_arr.slice!(0)
    if key
      key_exist?(key_arr, locale_hash[key]) if locale_hash && locale_hash.include?(key)
    elsif locale_hash
      true
    else
      false
    end
  end

  desc "Merge I18n keys from log/translations.yml into config/locales/*.yml (for use with the Rails I18n TextMate bundle)"
  task :merge_keys => :environment do
    I18n.backend.send(:init_translations)
    new_translations = YAML::load(IO.read(File.join(Rails.root, "log", "translations.yml")))
    raise("Can only merge in translations in single locale") if new_translations.keys.size > 1
    locale = new_translations.keys.first

    overwrites = false
    Translate::Keys.new.send(:extract_i18n_keys, new_translations[locale]).each do |key|
      new_text = key.split(".").inject(new_translations[locale]) { |hash, sub_key| hash[sub_key] }
      existing_text = I18n.backend.send(:lookup, locale.to_sym, key)
      if existing_text && new_text != existing_text
        puts "ERROR: key #{key} already exists with text '#{existing_text.inspect}' and would be overwritten by new text '#{new_text}'. " +
          "Set environment variable OVERWRITE=1 if you really want to do this."
        overwrites = true
      end
    end

    if !overwrites || ENV['OVERWRITE']
      I18n.backend.store_translations(locale, new_translations[locale])
      Translate::Storage.new(locale).write_to_file
    end
  end

  desc "Apply Google translate to auto translate all texts in locale ENV['FROM'] to locale ENV['TO']"
  task :google => :environment do
    raise "Please specify FROM and TO locales as environment variables" if ENV['FROM'].blank? || ENV['TO'].blank?

    # Depends on httparty gem
    # http://www.robbyonrails.com/articles/2009/03/16/httparty-goes-foreign
    class GoogleApi
      include HTTParty
      base_uri 'ajax.googleapis.com'
      def self.translate(string, to, from)
        tries = 0
        begin
          get("/ajax/services/language/translate",
            :query => {:langpair => "#{from}|#{to}", :q => string, :v => 1.0},
            :format => :json)
        rescue
          tries += 1
          puts("SLEEPING - retrying in 5...")
          sleep(5)
          retry if tries < 10
        end
      end
    end

    I18n.backend.send(:init_translations)

    start_at = Time.now
    translations = {}
    Translate::Keys.new.i18n_keys(ENV['FROM']).each do |key|
      from_text = I18n.backend.send(:lookup, ENV['FROM'], key).to_s
      to_text = I18n.backend.send(:lookup, ENV['TO'], key)
      if !from_text.blank? && to_text.blank?
        print "#{key}: '#{from_text[0, 40]}' => "
        if !translations[from_text]
          response = GoogleApi.translate(from_text, ENV['TO'], ENV['FROM'])
          translations[from_text] = response["responseData"] && response["responseData"]["translatedText"]
        end
        if !(translation = translations[from_text]).blank?
          translation.gsub!(/\(\(([a-z_.]+)\)\)/i, '{{\1}}')
          # Google translate sometimes replaces {{foobar}} with (()) foobar. We skip these
          if translation !~ /\(\(\)\)/
            puts "'#{translation[0, 40]}'"
            I18n.backend.store_translations(ENV['TO'].to_sym, Translate::Keys.to_deep_hash({key => translation}))
          else
            puts "SKIPPING since interpolations were messed up: '#{translation[0,40]}'"
          end
        else
          puts "NO TRANSLATION - #{response.inspect}"
        end
      end
    end

    puts "\nTime elapsed: #{(((Time.now - start_at) / 60) * 10).to_i / 10.to_f} minutes"
    Translate::Storage.new(ENV['TO'].to_sym).write_to_file
  end

  desc "List keys that have changed I18n texts between YAML file ENV['FROM_FILE'] and YAML file ENV['TO_FILE']. Set ENV['VERBOSE'] to see changes"
  task :changed => :environment do
    from_hash = Translate::Keys.to_shallow_hash(Translate::File.new(ENV['FROM_FILE']).read)
    to_hash = Translate::Keys.to_shallow_hash(Translate::File.new(ENV['TO_FILE']).read)
    from_hash.each do |key, from_value|
      if (to_value = to_hash[key]) && to_value != from_value
        key_without_locale = key[/^[^.]+\.(.+)$/, 1]
        if ENV['VERBOSE']
          puts "KEY: #{key_without_locale}"
          puts "FROM VALUE: '#{from_value}'"
          puts "TO VALUE: '#{to_value}'"
        else
          puts key_without_locale
        end
      end
    end
  end
end
