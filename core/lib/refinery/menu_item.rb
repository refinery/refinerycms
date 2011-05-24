module Refinery
  class MenuItem < HashWithIndifferentAccess

    attr_accessor :menu_instance

    (ATTRIBUTES = [:id, :title, :parent_id, :lft, :rgt, :url, :menu_match, :type]).each do |attribute|
      class_eval %{
        def #{attribute}
          @#{attribute} ||= self[:#{attribute}]
        end

        def #{attribute}=(attr)
          @#{attribute} = attr
        end
      }
    end

    def inspect
      hash = {}

      ATTRIBUTES.each do |attribute|
        hash[attribute] = self[attribute]
      end

      hash
    end

    def children
      @children ||= menu_instance.class.new(menu_instance.select{|item|
        item.type == self.type && item.parent_id == self.id
      })
    end

    def descendants
      @descendants ||= menu_instance.class.new(menu_instance.select{|item|
        item.type == self.type && item.lft > self.lft && item.rgt < self.rgt
      })
    end

    def has_descendants?
      @has_descendants ||= menu_instance.class.new(menu_instance.any?{|item|
        item.type == self.type && item.lft > self.lft && item.rgt < self.rgt
      })
    end

    def parent
      @parent ||= self.parent_id ? menu_instance.detect{ |item|
        item.type == self.type && item.id == self.parent_id
      } : nil
    end

    def siblings
      @siblings ||= menu_instance.class.new((parent.nil? ? menu_instance.roots : children) - [self])
    end
    alias_method :shown_siblings, :siblings

  end
end
