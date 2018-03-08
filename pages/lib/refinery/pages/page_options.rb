module Refinery
  module Pages

    def self.page_options
      @page_options ||= []
    end

    class PageOptions

      attr_accessor :name, :partial

      def self.register(&block)
        options = self.new

        yield options

        raise ArgumentError, "A page_option MUST have a name!: #{options.inspect}" if options.name.blank?
        raise ArgumentError, "A page_option MUST have a partial!: #{options.inspect}" if options.partial.blank?

        options
      end

      protected

      def initialize
        Refinery::Pages.page_options << self
      end

    end
  end
end
