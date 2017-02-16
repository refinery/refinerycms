module Refinery
  module MenuHelper

    # Adds conditional caching
    def cache_if(condition, name = {}, &block)
      Refinery.deprecate('cache_if', when: '3.1')

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
