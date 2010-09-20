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

    # Returns the internationalized version of the title
    def title
      ::I18n.translate("plugins.#{name}.title")
    end

    # Returns the internationalized version of the description
    def description
      ::I18n.translate("plugins.#{name}.description")
    end

    # Depreciation warning
    def title=(title)
      warn('title', caller)
    end

    # Depreciation warning
    def description=(description)
      warn('description', caller)
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
      return @url if defined?(@url)

      if self.controller.present?
        @url = {:controller => "/admin/#{self.controller}"}
      elsif self.directory.present?
        @url = {:controller => "/admin/#{self.directory.split('/').pop}"}
      else
        @url = {:controller => "/admin/#{self.name}"}
      end
    end

  protected

    def add_activity(options)
      (self.plugin_activity ||= []) << Activity::new(options)
    end

    # Make this protected, so that only Plugin.register can use it.
    def initialize
      # save the pathname to where this plugin is.
      depth = RUBY_VERSION == "1.9.2" ? -4 : -3
      self.pathname = Pathname.new(caller(3).first.split(File::SEPARATOR)[0..depth].join(File::SEPARATOR))
      Refinery::Plugins.registered << self # add me to the collection of registered plugins
    end

  private
    def warn(what, caller)
      warning = ["\n*** DEPRECATION WARNING ***"]
      warning << "You cannot use plugin.#{what} anymore."
      warning << "#{what.pluralize.titleize} will be internationalized by the I18n api."
      warning << ""
      warning << "See http://github.com/resolve/refinerycms/blob/master/vendor/refinerycms/core/engines.md#readme"
      warning << "Section: 'The Structure of a Plugin'"
      warning << ""
      warning << "Called from: #{caller.first.inspect}\n\n"
      $stdout.puts warning.join("\n")
    end
  end
end
