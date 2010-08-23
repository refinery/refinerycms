module Refinery
  module Engines; end;

  class Plugin

    def self.register(&block)
      plugin = self.new

      yield plugin

      if defined?(Page) && (reserved_word = plugin.controller.nil? ? plugin.name : plugin.controller)
        # Prevent page slugs from being this plugin's controller name
        Page.friendly_id_config.reserved_words << reserved_word
      end

      raise "A plugin MUST have a name!: #{plugin.inspect}" if plugin.name.nil?

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
    end

    attr_accessor :name, :class_name, :controller, :directory, :url, 
                  :version, :dashboard, :always_allow_access,
                  :menu_match, :hide_from_menu,
                  :pathname, :plugin_activity
    attr_reader   :description

    # Returns the class name of the plugin
    def class_name
      @class_name ||= name.camelize
    end

    # Rerturns the internationalized version of the title
    def title
      ::I18n.translate("plugins.#{name}.title")
    end

    # Returns the internationalized version of the description
    def description
      ::I18n.translate("plugins.#{name}.description")
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

    # Returns a hash that can be used to create a url that points to the administration part of the plugin.
    def url
      if defined?(@url)
        @url
      else
        if !self.controller.blank?
          @url = {:controller => "admin/#{self.controller}"}
        elsif !self.directory.blank?
          @url = {:controller => "admin/#{self.directory.split('/').pop}"}
        else
          @url = {:controller => "admin/#{self.name}"}
        end
      end
    end

  protected

    def add_activity(options)
      (self.plugin_activity ||= []) << Activity::new(options)
    end

    # Make this protected, so that only Plugin.register can use it.
    def initialize
      # Save the pathname to where this plugin is.
      file_path = (self.directory.present? ? self.directory : caller(3).first.split('/rails').first rescue nil)
      self.pathname = (Pathname.new(file_path.split(File::SEPARATOR)[0..-3].join(File::SEPARATOR)) unless file_path.nil?)
      Refinery::Plugins.registered << self # Add me to the collection of registered plugins
    end
  end
end
