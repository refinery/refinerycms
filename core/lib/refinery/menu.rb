module Refinery
  class Menu

    def initialize(objects = nil)
       append(objects)
    end

    def append(objects)
      Array(objects).each do |item|
        item = item.to_refinery_menu_item if item.respond_to?(:to_refinery_menu_item)
        items << MenuItem.new(self, item)
      end
    end

    attr_accessor :items

    def items
      @items ||= []
    end

    def roots
      @roots ||= select { |item| item.orphan? && item.depth == minimum_depth }
    end

    def to_s
      map(&:title).join(' ')
    end

    delegate :inspect, :map, :select, :detect, :first, :last, :length, :size, :to => :items

    protected

    def minimum_depth
      map(&:depth).compact.min
    end

  end
end
