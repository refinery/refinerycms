module Refinery
  class Version
    @major = 4
    @minor = 0
    @tiny  = 1
    @build = nil

    class << self
      attr_reader :major, :minor, :tiny, :build

      def to_s
        [@major, @minor, @tiny, @build].compact.join('.')
      end

      def required_ruby_version
        '>= 2.2.2'
      end
    end
  end
end