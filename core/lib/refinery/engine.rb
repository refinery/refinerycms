require 'active_support/concern'

module Refinery
  module Engine
    extend ActiveSupport::Concern

    module ClassMethods
      def refinery
        Refinery.config
      end
    end

    module InstanceMethods
      def refinery
        self.class.refinery
      end
    end
  end
end
