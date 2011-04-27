require 'rbconfig'

module Refinery

  WINDOWS = !!(RbConfig::CONFIG['host_os'] =~ %r!(msdos|mswin|djgpp|mingw)!) unless defined? WINDOWS

  autoload :Version, File.expand_path('../../refinery/version', __FILE__)

  class << self
    attr_accessor :base_cache_key, :gems, :rescue_not_found, :root, :roots, :s3_backend

    def base_cache_key
      @base_cache_key ||= :refinery
    end

    def engines
      @engines ||= []
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
