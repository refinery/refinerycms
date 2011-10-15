require 'active_support/concern'

module Refinery
  module Engine
    extend ActiveSupport::Concern

    module ClassMethods      
      def after_inclusion_procs
        @@after_inclusion_procs ||= []
      end

      def after_inclusion(&block)
        if block && block.respond_to?(:call)
          after_inclusion_procs << block
        else
          raise 'Anything added to be called before_inclusion must be callable.'
        end
      end

      def before_inclusion_procs
        @@before_inclusion_procs ||= []
      end

      def before_inclusion(&block)
        if block && block.respond_to?(:call)
          before_inclusion_procs << block
        else
          raise 'Anything added to be called before_inclusion must be callable.'
        end
      end
    end
  end
end
