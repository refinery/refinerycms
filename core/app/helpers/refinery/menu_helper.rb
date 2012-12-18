module Refinery
  module MenuHelper

    # Adds conditional caching
    def cache_if(condition, name = {}, &block)
      if condition
        cache(name, &block)
      else
        yield
      end

      # for <%= style helpers vs <% style
      nil
    end

  end
end
