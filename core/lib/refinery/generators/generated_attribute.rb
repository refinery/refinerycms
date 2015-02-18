require 'rails/generators/generated_attribute'

module Refinery
  module Generators
    class GeneratedAttribute < Rails::Generators::GeneratedAttribute
      class << self
        def reference?(type)
          [:references, :belongs_to, :image, :resource].include? type
        end
      end
    end
  end
end
