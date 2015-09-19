module Refinery
  module Pages

    def self.tabs
      @tabs ||= []
    end

    def self.tabs_for_template(template)
      return tabs unless template

      tabs.select do |tab|
        tab.templates.include?('all') || tab.templates.include?(template)
      end
    end

    class Tab
      attr_accessor :name, :partial, :templates

      def self.register(&block)
        tab = self.new

        yield tab

        raise ArgumentError, "A tab MUST have a name!: #{tab.inspect}" if tab.name.blank?
        raise ArgumentError, "A tab MUST have a partial!: #{tab.inspect}" if tab.partial.blank?

        tab.templates = %w[all] if tab.templates.blank?
        tab.templates = Array(tab.templates)

        tab
      end

    protected

      def initialize
        Refinery::Pages.tabs << self # add me to the collection of registered page tabs
      end
    end

  end
end
