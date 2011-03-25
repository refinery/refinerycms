require 'rails/engine'

module Refinery
  module Engine
    class << self
      def included(base)
        base.module_eval do
          class << self
            def refinery
              ::Refinery.config
            end
          end

          def refinery
            self.class.refinery
          end
        end
      end
    end
  end
end
