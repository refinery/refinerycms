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

    # TODO: Review necessary?
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

    def first_in_menu_with_url
      find(&:landable?)
    end

    def first_url_in_menu
      first_in_menu_with_url.try(:url)
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
        active.delete_if { |p| p.name == name}
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
