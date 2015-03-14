module Refinery
  module Testing
    module ControllerMacros
      module Methods

        extend ActiveSupport::Concern

        included do
          routes { Refinery::Core::Engine.routes }
        end
      end
    end
  end
end
