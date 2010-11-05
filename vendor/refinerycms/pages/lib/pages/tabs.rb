module Refinery
  module Pages

    attr_accessor :tabs

    def self.tabs
      @tabs ||= []
    end

    class Tab
      attr_accessor :name, :partial

      def self.register(&block)
        tab = self.new

        yield tab

        raise "A tab MUST have a name!: #{tab.inspect}" if tab.name.blank?
        raise "A tab MUST have a partial!: #{tab.inspect}" if tab.partial.blank?
      end

    protected

      def initialize
        ::Refinery::Pages.tabs << self # add me to the collection of registered page tabs
      end
    end

  end
end
