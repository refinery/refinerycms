module Refinery
  module Pages
    class Types < Array

      def register(name, &block)
        self.class.register(name, &block)
      end

      def find_by_name(name)
        detect { |type| type.name.to_s.downcase == name.to_s.downcase}
      end

      class << self
        def register(name, &block)
          type = Type.new
          type.name = name

          yield type if block_given?

          raise "A page type must have a name: #{self.inspect}" if type.name.blank?

          registered << type
        end

        def registered
          @registered_types ||= new
        end
      end

    end
  end
end
