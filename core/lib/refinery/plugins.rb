module Refinery
  class Plugins < Array

    def initialize
      @plugins = []
    end

    def find_activity_by_model(model)
      unless (plugin = find_by_model(model)).nil?
        plugin.activity.detect {|activity| activity.class == model}
      end
    end

    def find_by_model(model)
      model = model.constantize if model.is_a? String
      detect { |plugin| plugin.activity.any? {|activity| activity.class == model } }
    end

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
        new(registered.reject { |p| !p.always_allow_access? })
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

  end
end
