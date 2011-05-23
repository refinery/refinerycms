module Refinery
  class Menu

    def initialize(objects)
      objects.each do |item|
        menu_item = MenuItem.new(item)
        menu_item.menu_instance = self
        self.items << menu_item
      end
    end

    attr_accessor :items

    def items
      @items ||= []
    end

    def roots
      items.select {|item| item.parent_id.nil?}
    end

    def to_s
      rendering = ""

      self.items.each do |item|
        rendering << item.title
      end

      rendering
    end

    def inspect
      self.items.map(&:inspect)
    end

    delegate *(Array.instance_methods - Object.instance_methods), :to => :items
  end
end
