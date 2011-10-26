module Refinery
  module Engines; end;

  class Plugin

    attr_accessor :name, :class_name, :controller, :directory, :url,
                  :version, :dashboard, :always_allow_access,
                  :menu_match, :hide_from_menu,
                  :pathname, :plugin_activity
    attr_reader   :description

    def self.register(&block)
      yield(plugin = self.new)

      raise "A plugin MUST have a name!: #{plugin.inspect}" if plugin.name.blank?

      # Set the root as Rails::Engine.called_from will always be
      #                 vendor/engines/refinery/lib/refinery
      new_called_from = begin
        # Remove the line number from backtraces making sure we don't leave anything behind
        call_stack = caller.map { |p| p.split(':')[0..-2].join(':') }
        File.dirname(call_stack.detect { |p| p !~ %r[railties[\w\-\.]*/lib/rails|rack[\w\-\.]*/lib/rack] })
      end

      klass = Class.new(Rails::Engine)
      klass.class_eval <<-RUBY
        def self.called_from; "#{new_called_from}"; end
      RUBY
      Object.const_set(plugin.class_name.to_sym, klass)
      
      # add the new plugin to the collection of registered plugins
      ::Refinery::Plugins.registered << plugin
    end

    # Returns the class name of the plugin
    def class_name
      @class_name ||= name.camelize
    end

    # Returns the internationalized version of the title
    def title
      ::I18n.translate(['plugins', name, 'title'].join('.'))
    end

    # Returns the internationalized version of the description
    def description
      ::I18n.translate(['plugins', name, 'description'].join('.'))
    end

    # Retrieve information about how to access the latest activities of this plugin.
    def activity
      self.plugin_activity ||= []
    end

    # Stores information that can be used to retrieve the latest activities of this plugin
    def activity=(activities)
      [activities].flatten.each { |activity| add_activity(activity) }
    end

    # Returns true, if the user doesn't require plugin access
    def always_allow_access?
      @always_allow_access ||= false
    end

    # Special property to indicate that this plugin is the dashboard plugin.
    def dashboard?
      @dashboard ||= false
    end

    # Used to highlight the current tab in the admin interface
    def highlighted?(params)
      (params[:controller] =~ self.menu_match) or (self.dashboard? and params[:action] == 'error_404')
    end

    # Returns a RegExp that matches, if the current page is part of the plugin.
    def menu_match
      @menu_match ||= /(admin|refinery)\/#{self.name}$/
    end

    def pathname=(value)
      value = Pathname.new(value) if value.is_a? String
      @pathname = value
    end

    # Returns a hash that can be used to create a url that points to the administration part of the plugin.
    def url
      @url ||= if self.controller.present?
        {:controller => "/admin/#{self.controller}"}
      elsif self.directory.present?
        {:controller => "/admin/#{self.directory.split('/').pop}"}
      else
        {:controller => "/admin/#{self.name}"}
      end
    end

  # Make this protected, so that only Plugin.register can use it.
  protected

    def add_activity(options)
      (self.plugin_activity ||= []) << Activity::new(options)
    end

    def initialize
      # provide a default pathname to where this plugin is using its lib directory.
      depth = RUBY_VERSION >= "1.9.2" ? 4 : 3
      self.pathname ||= Pathname.new(caller(depth).first.match("(.*)#{File::SEPARATOR}lib")[1])
    end
  end
end
