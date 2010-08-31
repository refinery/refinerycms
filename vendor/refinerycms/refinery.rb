module Refinery

  class << self
    attr_accessor :is_a_gem, :root, :s3_backend, :base_cache_key
    def is_a_gem
      @is_a_gem ||= false
    end

    def root
      @root ||= Pathname.new(File.expand_path(__FILE__).split('vendor').first.to_s)
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
    @major = 0
    @minor = 9
    @tiny  = 8
    @build = nil

    class << self
      attr_reader :major, :minor, :tiny, :build

      def to_s
        [@major, @minor, @tiny, @build].compact.join('.')
      end
    end
  end
end
