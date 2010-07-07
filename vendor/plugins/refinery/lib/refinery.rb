module Refinery

  class << self
    attr_accessor :is_a_gem, :root, :s3_backend, :base_cache_key
    def is_a_gem
      @is_a_gem ||= false
    end

    def root
      @root ||= Pathname.new(File.dirname(__FILE__).split("vendor").first.to_s)
    end

    def s3_backend
      @s3_backend ||= false
    end

    def base_cache_key
      @base_cache_key ||= "refinery"
    end

    def version
      ::Refinery::Version.to_s
    end
  end

  class Version
    MAJOR = 0
    MINOR = 9
    TINY = 7
    BUILD = 3

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join('.')

    def self.to_s
      STRING
    end
  end

end
