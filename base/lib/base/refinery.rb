require 'rbconfig'

module Refinery

  WINDOWS = !!(RbConfig::CONFIG['host_os'] =~ %r!(msdos|mswin|djgpp|mingw)!) unless defined? WINDOWS

  autoload :Version, File.expand_path('../../refinery/version', __FILE__)

  class << self
    attr_accessor :base_cache_key, :gems, :rescue_not_found, :root, :roots, :s3_backend

    def base_cache_key
      @base_cache_key ||= :refinery
    end

    def deprecate(options = {})
      # Build a warning.
      warning = "\n-- DEPRECATION WARNING --"
      warning << "\nThe use of '#{options[:what]}' is deprecated"
      warning << " and will be removed at version #{options[:when]}." if options[:when]
      warning << "\nPlease use #{options[:replacement]} instead." if options[:replacement]

      # See if we can trace where this happened
      if options[:caller]
        whos_calling = options[:caller].detect{|c| c =~ %r{#{Rails.root.to_s}}}.inspect.to_s.split(':in').first
        warning << "\nCalled from: #{whos_calling}\n"
      end

      # Give stern talking to.
      warn warning
    end

    def engines
      @engines ||= []
    end

    def i18n_enabled?
      !!(defined?(::Refinery::I18n) && ::Refinery::I18n.enabled?)
    end

    def rescue_not_found
      !!@rescue_not_found
    end

    def root
      @root ||= Pathname.new(File.expand_path('../../../../../', __FILE__))
    end

    def roots(engine_name = nil)
      if engine_name.nil?
        @roots ||= self.engines.map {|engine| "Refinery::#{engine.camelize}".constantize.root }.uniq
      else
        unless (engine_name = self.engines.detect{|engine| engine.to_s == engine_name.to_s}).nil?
          "Refinery::#{engine_name.camelize}".constantize.root
        end
      end
    end

    def s3_backend
      @s3_backend ||= false
    end

    def version
      ::Refinery::Version.to_s
    end
  end
end
