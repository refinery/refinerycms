module Refinery
  class Configuration

    def after_inclusion_procs
      @@after_inclusion_procs ||= []
    end

    def after_inclusion(&blk)
      after_inclusion_procs << blk if blk
    end

    def before_inclusion_procs
      @@before_inclusion_procs ||= []
    end

    def before_inclusion(&blk)
      before_inclusion_procs << blk if blk
    end

  end
end
