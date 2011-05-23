module Refinery
  class Menu

    def initialize(objects)
      objects.each do |item|
        self.items << MenuItem.new(item)
      end
    end

    attr_accessor :items

    def items
      @items ||= []
    end

    def to_s
      rendering = ""

      self.items.each do |item|
        rendering << item.title
      end

      rendering
    end
    
    def inspect
      self.items.map{|i| [i.class.to_s, i.inspect].join(":")}
    end
    
    delegate :length, :first, :last, :[], :[]=, :to => :items
  end
end