require 'rbconfig'

module Refinery

  WINDOWS = !!(RbConfig::CONFIG["host_os"] =~ %r!(msdos|mswin|djgpp|mingw)!) unless defined? WINDOWS

  autoload :Version, File.expand_path('../refinery/version', __FILE__)

  class << self
    attr_accessor :root, :s3_backend, :base_cache_key, :rescue_not_found

    def root
      @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
    end

    def s3_backend
      @s3_backend ||= false
    end

    def base_cache_key
      @base_cache_key ||= :refinery
    end

    def rescue_not_found
      !!@rescue_not_found
    end

    def version
      ::Refinery::Version.to_s
    end
  end
end
