module Refinery
  module Engines; end;

  class Plugin

    def self.register(&block)
      plugin = self.new
      yield plugin
      if defined?(Page) && plugin.title
        # Prevent page slugs from being this plugin's controller name
        Page.friendly_id_config.reserved_words << plugin.title.gsub(" ", "_").downcase
      end
      klass_name = plugin.title == 'Refinery' ? 'RefineryEngine' : plugin.title
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
      Object.const_set(klass_name.to_sym, klass)
    end

    attr_accessor :always_allow_access, :dashboard, :description, :directory,
                  :hide_from_menu, :menu_match, :name, :pathname, :plugin_activity,
                  :title, :url, :version

    def initialize
      # save the pathname to where this plugin is.
      file_path = (self.directory.present? ? self.directory : caller(3).first.split('/rails').first rescue nil)
      self.pathname = (Pathname.new(file_path.split(File::SEPARATOR)[0..-3].join(File::SEPARATOR)) unless file_path.nil?)
      Refinery::Plugins.registered << self # add me to the collection of registered plugins
    end

    def activity
      self.plugin_activity ||= []
    end

    def activity=(activities)
      [activities].flatten.each { |activity| add_activity(activity) }
    end

    def add_activity(options)
      (self.plugin_activity ||= []) << Activity::new(options)
    end

    def always_allow_access
      @always_allow_access ||= false
    end

    def name
      # we have to use @title not def title because def title translates based on name (circular reference)
      @name ||= @title.to_s.downcase.gsub(' ', '_')
    end

    def dashboard?
      @dashboard ||= false
    end

    def title
      ::I18n.translate("plugins.#{name}.title", :default => @title)
    end

    def highlighted?(params)
      (params[:controller] =~ self.menu_match) or (self.dashboard? and params[:action] == 'error_404')
    end

    def menu_match
      @menu_match ||= /(admin|refinery)\/#{self.name}$/
    end

    def url
      @url ||= {:controller => "admin/#{self.directory.blank? ? self.title.gsub(" ", "_").downcase : self.directory.split('/').pop}"}
    end

  end
end
