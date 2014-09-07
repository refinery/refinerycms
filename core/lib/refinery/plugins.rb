require 'forwardable'

module Refinery
  class Plugins
    include Enumerable
    extend Forwardable

    def initialize(*args)
      @plugins = Array.new(*args)
    end

    def_delegators :@plugins, :<<, :each, :delete_if

    def find_by_name(name)
      detect { |plugin| plugin.name == name }
    end
    alias :[] :find_by_name

    def find_by_title(title)
      detect { |plugin| plugin.title == title }
    end

    def in_menu
      self.class.new(reject(&:hide_from_menu))
    end

    def names
      map(&:name)
    end

    def pathnames
      map(&:pathname).compact.uniq
    end

    def titles
      map(&:title)
    end

    class << self
      def active
        @active_plugins ||= new
      end

      def always_allowed
        new registered.select(&:always_allow_access)
      end

      def registered
        @registered_plugins ||= new
      end

      def activate(name)
        active << registered[name] if registered[name] && !active[name]
      end

      def deactivate(name)
        active.delete_if {|p| p.name == name}
      end

      def set_active(names)
        @active_plugins = new

        names.each do |name|
          activate(name)
        end
      end
    end

    private

    attr_reader :plugins
  end
end
