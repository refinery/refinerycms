module Refinery
  module Pages
    class Type

      attr_accessor :name, :parts, :template

      def parts=(new_parts)
        @parts = if new_parts.all? { |v| v.is_a?(String) }
          new_syntax = new_parts.map do |part|
            { title: part, slug: part.downcase.gsub(" ", "_") }
          end
          Refinery.deprecate(
            "Change Refinery::Pages.default_parts= from #{@parts} to #{new_syntax}",
            when: "4.1.0"
          )
          new_syntax
        else
          new_parts
        end
      end

      def parts
        @parts ||= []
      end

      def template
        @template ||= "refinery/pages/#{name}"
      end

    end
  end
end
