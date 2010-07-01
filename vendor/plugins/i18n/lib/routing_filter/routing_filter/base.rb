module RoutingFilter
  class Base
    class_inheritable_accessor :active
    self.active = true

    attr_accessor :chain, :options

    def initialize(options = {})
      @options = options
      options.each { |name, value| instance_variable_set :"@#{name}", value }
    end

    def run(method, *args, &block)
      _next = successor ? lambda { successor.run(method, *args, &block) } : block
      active ? send(method, *args, &_next) : _next.call(*args)
    end

    def run_reverse(method, *args, &block)
      _prev = predecessor ? lambda { predecessor.run(method, *args, &block) } : block
      active ? send(method, *args, &_prev) : _prev.call(*args)
    end

    def predecessor
      @chain.predecessor(self)
    end

    def successor
      @chain.successor(self)
    end
  end
end
