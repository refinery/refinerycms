require 'forwardable'

module Refinery
  class Plugins
    include Enumerable
    extend Forwardable

    def initialize(*args)
      @plugins = Array.new(*args)
    end

    def_delegators :@plugins, :<<, :each, :delete_if, :length, :size, :to_ary, :unshift

    def find_by_name(name)
      detect { |plugin| plugin.name == name }
    end
    alias :[] :find_by_name

    def find_by_title(title)
      detect { |plugin| plugin.title == title }
    end

    # TODO: Review necessary?
    def in_menu
      items_in_menu = reject(&:hide_from_menu)
      self.class.new((prioritised & items_in_menu) | items_in_menu)
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

    def update_positions(plugin_list)
      plugins = plugin_list.map {|p| find_by_name(p) }.reject(&:blank?)
      plugins.each_with_index do |plugin, index|
        plugin.update_attributes(position: index)
      end
    end

    class << self
      def always_allowed
        new registered.select(&:always_allow_access)
      end

      def registered
        @registered_plugins ||= new
      end
    end

    private

    attr_reader :plugins

    def prioritised
      Refinery::Core.config.plugin_priority.map { |name| find_by_name(name) }
    end
  end
end
