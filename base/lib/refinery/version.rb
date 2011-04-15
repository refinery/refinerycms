module Refinery
  class Version
    @major = 0
    @minor = 9
    @tiny  = 9
    @build = 18

    class << self
      attr_reader :major, :minor, :tiny, :build

      def to_s
        [@major, @minor, @tiny, @build].compact.join('.')
      end
    end
  end
end
