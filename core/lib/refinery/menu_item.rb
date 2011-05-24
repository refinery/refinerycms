module Refinery
  class MenuItem < HashWithIndifferentAccess

    (ATTRIBUTES = [:id, :title, :parent_id, :lft, :rgt, :url, :menu_id, :menu_match, :type]).each do |attribute|
      class_eval %{
        def #{attribute}
          @#{attribute} ||= self[:#{attribute}]
        end

        def #{attribute}=(attr)
          @#{attribute} = attr
        end
      }
    end

    def children
      @children ||= if has_children?
        menu.class.new(menu.select{|item| item.type == type && item.parent_id == id})
      else
        menu.class.new
      end
    end

    def descendants
      @descendants ||= if has_descendants?
        menu.class.new(menu.select{|item|
          item.type == type && item.lft > lft && item.rgt < rgt
        })
      else
        menu.class.new
      end
    end

    def has_children?
      @has_children ||= (rgt > lft + 1)
    end
    # really, they're the same.
    alias_method :has_descendants?, :has_children?

    def inspect
      hash = {}

      ATTRIBUTES.each do |attribute|
        hash[attribute] = self[attribute]
      end

      hash
    end

    def menu
      ::Refinery.menus[menu_id]
    end

    def parent
      @parent ||= (menu.detect{|item| item.type == type && item.id == parent_id} if parent_id)
    end

    def siblings
      @siblings ||= menu.class.new((parent.nil? ? menu.roots : children) - [self])
    end
    alias_method :shown_siblings, :siblings

  end
end
