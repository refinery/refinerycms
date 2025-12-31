require 'rails/generators/generated_attribute'

module Refinery
  module Generators
    class GeneratedAttribute < Rails::Generators::GeneratedAttribute
      REFINERY_TYPES = %w(image resource radio select checkbox)

      attr_accessor :refinery_type

      class << self
        def parse(column_definition)
          name, type, index_type = column_definition.split(":")

          # Handle Refinery's custom types before Rails validates them
          if type && REFINERY_TYPES.include?(type)
            new(name, type.to_sym, index_type)
          else
            super
          end
        end

        def reference?(type)
          [:references, :belongs_to, :image, :resource].include? type
        end
      end

      def initialize(name, type=nil, index_type=false, attr_options={})
        super
        self.refinery_type  = type
        self.type           = refinerize_type(type)
      end

      def reference?
        self.class.reference?(refinery_type)
      end

      private

      def refinerize_type(type)
        if refinery_engine_type?(type)
          :integer
        elsif  refinery_form_type?(type)
          if type == :checkbox
            :boolean
          else
            :string
          end
        else
          type
        end
      end

      def refinerize_name(name, type)
        refinery_engine_type?(type) ? "#{name}_id".gsub("_id_id", "_id") : name
      end

      def refinery_form_type?(type)
        [:radio, :select, :checkbox].include? type

      end

      def refinery_engine_type?(type)
        [:image, :resource].include? type
      end
    end
  end
end
