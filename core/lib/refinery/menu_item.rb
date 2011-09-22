module Refinery
  class MenuItem < HashWithIndifferentAccess

    class << self
      def attributes
        [:title, :parent_id, :lft, :rgt, :depth, :url, :menu_id, :menu_match]
      end

      def apply_attributes!
        attributes.each do |attribute|
          class_eval %{
            def #{attribute}
              @#{attribute} ||= self[:#{attribute}]
            end
          } unless self.respond_to?(attribute)
          class_eval %{
            def #{attribute}=(attr)
              @#{attribute} = attr
            end
          } unless self.respond_to?(:"#{attribute}=")
        end
      end
    end

    def original_id
      @original_id ||= self[:id]
    end

    def original_type
      @original_type ||= self[:type]
    end

    apply_attributes!

    def ancestors
      return @ancestors if @ancestors
      @ancestors = []
      p = self
      @ancestors << p until(p = p.parent).nil?

      @ancestors
    end

    def children
      @children ||= if has_children?
        menu.select { |item| item.original_type == original_type && item.parent_id == original_id }
      else
        []
      end
    end

    def descendants
      @descendants ||= if has_descendants?
        menu.select{|item| item.original_type == original_type && item.lft > lft && item.rgt < rgt}
      else
        []
      end
    end

    def has_children?
      @has_children ||= (rgt > lft + 1)
    end
    # really, they're the same.
    alias_method :has_descendants?, :has_children?

    def has_parent?
      !parent_id.nil?
    end

    def inspect
      hash = {}

      self.class.attributes.each do |attribute|
        hash[attribute] = self[attribute]
      end

      hash.inspect
    end

    def menu
      ::Refinery.menus[menu_id]
    end

    def parent
      @parent ||= (menu.detect{|item| item.original_type == original_type && item.original_id == parent_id} if has_parent?)
    end

    def siblings
      @siblings ||= ((has_parent? ? parent.children : menu.roots) - [self])
    end
    alias_method :shown_siblings, :siblings
  end
end
