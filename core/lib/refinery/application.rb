module Refinery
  module Application

    class << self
      def included(base)
        self.instance_eval %(
          def self.method_missing(method_sym, *arguments, &block)
            #{base}.send(method_sym)
          end
        )
      end
    end
    
  end
end
