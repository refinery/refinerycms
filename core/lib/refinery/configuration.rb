module Refinery
  class Configuration

    def add_class(name)
      self.instance_variable_set("@#{name}", Set.new)

      create_method("#{name}=".to_sym) do |value|
        instance_variable_set("@#{name}", value)
      end

      create_method(name.to_sym) do
        instance_variable_get("@#{name}")
      end
    end

    private

      def create_method(name, &block)
        self.class.send(:define_method, name, &block)
      end

  end
end
