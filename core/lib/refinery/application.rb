module Refinery
  module Application

    class << self

      def refinery!
        ::Refinery.config.before_inclusion_procs.each(&:call)

        ::ApplicationHelper.send :include, ::Refinery::ApplicationHelper

        [::ApplicationController, ::Refinery::AdminController].each do |c|
          c.send :include, ::Refinery::ApplicationController
          c.send :helper, :application
        end

        ::Refinery::AdminController.send :include, ::Refinery::Admin::BaseController

        ::Refinery.config.after_inclusion_procs.each(&:call)
      end

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
