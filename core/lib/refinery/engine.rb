module Refinery
  module Engine
    # Specify a block of code to be run after the refinery inclusion step. See
    # Refinery::Core::Engine#refinery_inclusion for details regarding the Refinery
    # inclusion process.
    #
    # Example:
    #   module Refinery
    #     module Images
    #       class Engine < Rails::Engine
    #         extend Refinery::Engine
    #         engine_name :images
    #
    #         after_inclusion do
    #           # perform something here
    #         end
    #       end
    #     end
    #   end
    def after_inclusion(&block)
      if block && block.respond_to?(:call)
        after_inclusion_procs << block
      else
        raise 'Anything added to be called after_inclusion must be callable (respond to #call).'
      end
    end

    # Specify a block of code to be run before the refinery inclusion step. See
    # Refinery::Core::Engine#refinery_inclusion for details regarding the Refinery
    # inclusion process.
    #
    # Example:
    #   module Refinery
    #     module Images
    #       class Engine < Rails::Engine
    #         extend Refinery::Engine
    #         engine_name :images
    #
    #         before_inclusion do
    #           # perform something here
    #         end
    #       end
    #     end
    #   end
    def before_inclusion(&block)
      if block && block.respond_to?(:call)
        before_inclusion_procs << block
      else
        raise 'Anything added to be called before_inclusion must be callable (respond to #call).'
      end
    end

    private
    def after_inclusion_procs
      @@after_inclusion_procs ||= []
    end

    def before_inclusion_procs
      @@before_inclusion_procs ||= []
    end
  end
end
