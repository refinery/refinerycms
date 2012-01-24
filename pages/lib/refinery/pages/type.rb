module Refinery
  module Pages
    class Type

      attr_accessor :name, :parts, :template

      def parts
        @parts ||= []
      end

      def template
        @template ||= "refinery/pages/#{name}"
      end

    end
  end
end
