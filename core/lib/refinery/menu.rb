module Refinery

  # Create a little something to store the instances of the menu.
  class << self
    attr_accessor :menus
    def menus
      @@menus ||= HashWithIndifferentAccess.new
    end
  end

  class Menu

    def initialize(objects = nil)
      objects.each do |item|
        item = item.to_refinery_menu_item if item.respond_to?(:to_refinery_menu_item)
        items << MenuItem.new(item.merge(:menu_id => id))
      end if objects

      ::Refinery.menus[self.id] = self
    end

    attr_accessor :items, :id

    def id
      require 'securerandom' unless defined?(::SecureRandom)
      @id ||= ::SecureRandom.hex(8)
    end

    def items
      @items ||= []
    end

    def roots
      @roots ||= items.select {|item| item.parent_id.nil?}
    end

    def to_s
      items.map(&:title).join(' ')
    end

    def inspect
      items.map(&:inspect)
    end

    # The delegation is specified so crazily so that it works on 1.8.x and 1.9.x
    delegate *((Array.instance_methods - Object.instance_methods) << {:to => :items})
  end
end
