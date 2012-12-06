module Refinery
  class Menu

    def initialize(objects = nil)
      objects.each do |item|
        item = item.to_refinery_menu_item if item.respond_to?(:to_refinery_menu_item)
        items << MenuItem.new(item.merge(:menu => self))
      end if objects
    end

    attr_accessor :items

    def items
      @items ||= []
    end

    def roots
      @roots ||= items.select(&:orphan?)
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
