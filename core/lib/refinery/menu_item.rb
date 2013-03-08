module Refinery
  class MenuItem

    attr_accessor :menu, :title, :parent_id, :lft, :rgt, :depth, :url, :menu_match, :html,
                  :original_type, :original_id

    def initialize(menu, options = {})
      @menu = menu
      remap!(options).each do |key, value|
        send "#{key}=", value
      end
    end

    def remap!(options)
      options[:original_id] = options.delete(:id)
      options[:original_type] = options.delete(:type)
      options
    end

    def ancestors
      @ancestors ||= generate_ancestors
    end

    def children
      @children ||= generate_children
    end

    def descendants
      @descendants ||= generate_descendants
    end

    def has_children?
      !leaf?
    end
    alias_method :has_descendants?, :has_children? # really, they're the same.

    def has_parent?
      !parent_id.nil?
    end

    def orphan?
      !has_parent?
    end

    def leaf?
      @leaf ||= rgt.to_i - lft.to_i == 1
    end

    def parent
      @parent ||= ancestors.detect { |item| item.original_id == parent_id }
    end

    def siblings
      @siblings ||= ((has_parent? ? parent.children : menu.roots) - [self])
    end
    alias_method :shown_siblings, :siblings

    private
    # At present a MenuItem can only have children of the same type to avoid id
    # conflicts like a Blog::Post and a Page both having an id of 42
    def compatible_with?(item)
      original_type == item.original_type
    end

    def generate_ancestors
      if has_parent?
        menu.select { |item| compatible_with?(item) && item.lft < lft && item.rgt > rgt }
      else
        []
      end
    end

    def generate_children
      descendants.select { |item| item.parent_id == original_id }
    end

    def generate_descendants
      if has_descendants?
        menu.select { |item| compatible_with?(item) && item.lft > lft && item.rgt < rgt }
      else
        []
      end
    end
  end
end
