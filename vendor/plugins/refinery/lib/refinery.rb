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
    class << self
      attr_reader :major, :minor, :tiny, :build
    end

    @major = 0
    @minor = 9
    @tiny  = 7
    @build = 13

    def self.to_s
      [@major, @minor, @tiny, @build].compact.join('.')
    end
  end

end
