module Refinery
  class Version
    @major = 3
    @minor = 0
    @tiny  = 0
    @build = nil

    class << self
      attr_reader :major, :minor, :tiny, :build

      def to_s
        [@major, @minor, @tiny, @build].compact.join('.')
      end

      def required_ruby_version
        '>= 2.0.0'
      end
    end
  end
end
