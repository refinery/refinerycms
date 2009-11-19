module ActiveRecord
  module Acts
    module Tree
      def self.included(base)
        base.extend(ClassMethods)
      end

      # Specify this +acts_as+ extension if you want to model a tree structure by providing a parent association and a children
      # association. This requires that you have a foreign key column, which by default is called +parent_id+.
      #
      #   class Category < ActiveRecord::Base
      #     acts_as_tree :order => "name"
      #   end
      #
      #   Example:
      #   root
      #    \_ child1
      #         \_ subchild1
      #         \_ subchild2
      #
      #   root      = Category.create("name" => "root")
      #   child1    = root.children.create("name" => "child1")
      #   subchild1 = child1.children.create("name" => "subchild1")
      #
      #   root.parent   # => nil
      #   child1.parent # => root
      #   root.children # => [child1]
      #   root.children.first.children.first # => subchild1
      #
      # In addition to the parent and children associations, the following instance methods are added to the class
      # after calling <tt>acts_as_tree</tt>:
      # * <tt>siblings</tt> - Returns all the children of the parent, excluding the current node (<tt>[subchild2]</tt> when called on <tt>subchild1</tt>)
      # * <tt>self_and_siblings</tt> - Returns all the children of the parent, including the current node (<tt>[subchild1, subchild2]</tt> when called on <tt>subchild1</tt>)
      # * <tt>ancestors</tt> - Returns all the ancestors of the current node (<tt>[child1, root]</tt> when called on <tt>subchild2</tt>)
      # * <tt>root</tt> - Returns the root of the current node (<tt>root</tt> when called on <tt>subchild2</tt>)
      # * <tt>descendants</tt> - Returns a flat list of the descendants of the current node (<tt>[child1, subchild1, subchild2]</tt> when called on <tt>root</tt>)
      module ClassMethods
        # Configuration options are:
        #
        # * <tt>foreign_key</tt> - specifies the column name to use for tracking of the tree (default: +parent_id+)
        # * <tt>order</tt> - makes it possible to sort the children according to this SQL snippet.
        # * <tt>counter_cache</tt> - keeps a count in a +children_count+ column if set to +true+ (default: +false+).
        # * <tt>include</tt> - ability to add eager loading to tree finds by specifying associations to include. 'children' association eager loaded by default. Disable by supplying :include => nil or :include => []
        def acts_as_tree(options = {})
          configuration = { :foreign_key => "parent_id", :order => nil, :counter_cache => nil, :include => [:children] }
          configuration.update(options) if options.is_a?(Hash) # to avoid something nasty happening check for Hash here.
          configuration.update({:include => []}) if configuration[:include].nil? # if calling class really doesn't want to eager load its children.

          belongs_to :parent, :class_name => name, :foreign_key => configuration[:foreign_key], :counter_cache => configuration[:counter_cache], :include => configuration[:include]
          has_many :children, :class_name => name, :foreign_key => configuration[:foreign_key], :order => configuration[:order], :dependent => :delete_all, :include => configuration[:include]

          class_eval <<-EOV
            include ActiveRecord::Acts::Tree::InstanceMethods

            def self.roots
              find :all, :conditions => "#{configuration[:foreign_key]} IS NULL", :order => #{configuration[:order].nil? ? "nil" : %Q{"#{configuration[:order]}"}}, :include => %W{#{configuration[:include].join(' ')}}
            end

            def self.root
              find :first, :conditions => "#{configuration[:foreign_key]} IS NULL", :order => #{configuration[:order].nil? ? "nil" : %Q{"#{configuration[:order]}"}}, :include => %W{#{configuration[:include].join(' ')}}
            end

            def self.childless
              nodes = []

              find(:all, :include => configuration[:include]).each do |node|
                nodes << node if node.children.empty?
              end

              nodes
            end
          EOV
        end
      end

      module InstanceMethods
        # Returns list of ancestors, starting from parent until root.
        #
        #   subchild1.ancestors # => [child1, root]
        def ancestors
          node, nodes = self, []
          nodes << node = node.parent until node.parent.nil? and return nodes
        end

        # Returns the root node of the tree.
        def root
          node = self
          node = node.parent until node.parent.nil? and return node
        end

        # Returns all siblings of the current node.
        #
        #   subchild1.siblings # => [subchild2]
        def siblings
          self_and_siblings - [self]
        end

        # Returns all siblings and a reference to the current node.
        #
        #   subchild1.self_and_siblings # => [subchild1, subchild2]
        def self_and_siblings
          parent ? parent.children : self.class.roots
        end

        # Returns a flat list of the descendants of the current node.
        #
        #   root.descendants # => [child1, subchild1, subchild2]
        def descendants(node=self)
          nodes = []
          nodes << node unless node == self

          node.children.each do |child|
            nodes += descendants(child)
          end

          nodes.compact
        end

        def chain
          [self.ancestors, self, self.descendants].flatten
        end

        # Returns a flat list of all of the children under the current node
        # which don't have any children belonging to them (childless)
        #
        #   node.childess # => [subchild1, subchild2]
        def childless
          nodes = []

          unless self.children.empty?
            nodes << self.children.collect { |child| child.childless }
          else
            nodes << self
          end

          nodes.flatten.compact
        end
      end
    end
  end
end
