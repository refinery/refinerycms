module Refinery
  class Configuration

    def on_attach_procs
      @@on_attach_procs ||= []
    end

    def on_attach(&blk)
      on_attach_procs << blk if blk
    end

  end
end
