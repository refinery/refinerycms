require 'rails/generators/named_base'

module Refinery
  module Generators
    class NamedBase < Rails::Generators::NamedBase

      protected

      def parse_attributes! #:nodoc:
        self.attributes = (attributes || []).map do |attr|
          Refinery::Generators::GeneratedAttribute.parse(attr)
        end
      end
    end
  end
end
