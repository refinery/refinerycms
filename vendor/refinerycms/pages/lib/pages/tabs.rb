module Refinery
  module Pages

    attr_accessor :tabs

    def self.tabs
      @tabs ||= []
    end

    class Tab
      attr_accessor :name, :template

      def self.register(&block)
        tab = self.new

        yield tab

        raise "A tab MUST have a name!: #{tab.inspect}" if tab.name.nil?
        raise "A tab MUST have a template!: #{tab.inspect}" if tab.template.nil?
      end

    protected

      def initialize
        ::Refinery::Pages.tabs << self # add me to the collection of registered page tabs
      end
    end

  end
end
