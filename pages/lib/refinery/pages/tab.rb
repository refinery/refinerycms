module Refinery
  module Pages

    attr_accessor :tabs

    def self.tabs
      @tabs ||= []
    end
    
    def self.tabs_for_template(template)
      tabs.select{|t| t.templates.include?('all') || t.templates.include?(template) }
    end

    class Tab
      attr_accessor :name, :partial, :templates

      def self.register(&block)
        tab = self.new

        yield tab

        raise "A tab MUST have a name!: #{tab.inspect}" if tab.name.blank?
        raise "A tab MUST have a partial!: #{tab.inspect}" if tab.partial.blank?
        tab.templates = %w[all] if tab.templates.empty?
        tab.templates = Array(tab.templates)
      end

    protected

      def initialize
        ::Refinery::Pages.tabs << self # add me to the collection of registered page tabs
      end
    end

  end
end
