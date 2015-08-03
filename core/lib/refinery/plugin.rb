module Refinery
  class Plugin
    META = {
      "refinery_dashboard"    => {position: 0 , icon: 'icon icon-dashboard'},
      "refinery_pages"        => {position: 5, icon: 'icon icon-pages'     },
      "refinerycms_blog"      => {position: 15, icon: 'icon icon-feather'  },
      "refinerycms_inquiries" => {position: 85, icon: 'icon icon-chat'     },
      "refinery_users"        => {position: 90, icon: 'icon icon-group'    },
      "refinery_settings"     => {position: 0 , icon: 'icon icon-wrench'   }, #hide
      "refinery_images"       => {position: 0 , icon: 'icon icon-wrench'   }, #hide
      "refinery_files"        => {position: 0 , icon: 'icon icon-wrench'   }, #hide
    }

    META.default     =  {position: 50, icon: 'icon icon-wrench'}

    attr_accessor :name, :class_name, :controller, :directory, :url,
                  :always_allow_access, :menu_match, :hide_from_menu,
                  :pathname

    def self.register(&block)
      yield(plugin = self.new)

      raise "A plugin MUST have a name!: #{plugin.inspect}" if plugin.name.blank?

      # Set defaults.
      plugin.menu_match ||= %r{refinery/#{plugin.name}(/.+?)?$}
      plugin.always_allow_access ||= false
      plugin.class_name ||= plugin.name.camelize

      # add the new plugin to the collection of registered plugins
      ::Refinery::Plugins.registered << plugin
    end

    # Returns the internationalized version of the title
    def title
      ::I18n.translate(['refinery', 'plugins', name, 'title'].join('.'))
    end

    # Returns the internationalized version of the description
    def description
      ::I18n.translate(['refinery', 'plugins', name, 'description'].join('.'))
    end

    # Stores information that can be used to retrieve the latest activities of this plugin
    def activity=(activities)
      Refinery.deprecate('Refinery::Plugin#activity=', when: '3.1')
    end

    def dashboard=(dashboard)
      Refinery.deprecate('Refinery::Plugin#dashboard=', when: '3.1')
    end

    # Used to highlight the current tab in the admin interface
    def highlighted?(params)
      !!(params[:controller].try(:gsub, "admin/", "") =~ menu_match)
    end

    def pathname=(value)
      value = Pathname.new(value) if value.is_a? String
      @pathname = value
    end

    # Returns a hash that can be used to create a url that points to the administration part of the plugin.
    def url
      @url ||= build_url

      if @url.is_a?(Hash)
        {:only_path => true}.merge(@url)
      elsif @url.respond_to?(:call)
        @url.call
      else
        @url
      end
    end

    def version
      Refinery.deprecate "Refinery::Plugin#version", :when => '2.2',
                         :caller => caller.detect{|c| /#{pathname}/ === c }
    end

    def version=(*args)
      Refinery.deprecate "Refinery::Plugin#version=", :when => '2.2',
                         :caller => caller.detect{|c| /#{pathname}/ === c }
    end

    def position
      positions_override = Refinery::Core.config.backend_menu_positions
      return positions_override[self.name] if (positions_override.present? && positions_override.has_key?(self.name))
      return @position                     if @position
      return Refinery::Plugin::META[self.name][:position]
    end

    def position=(val)
      @position = val
    end

    def icon
      icons_override = Refinery::Core.config.backend_menu_icons
      return icons_override[self.name] if icons_override.present? && icons_override.has_key?(self.name)
      return @icon_str                 if @icon_str
      return Refinery::Plugin::META[self.name][:icon]
    end

    def icon=(val)
      @icon_str = val
    end

    def show_for_superuser_only=(val)
      @show_for_superuser_only = val
    end

    def show_for_superuser_only
      return @show_for_superuser_only
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

    private

    def build_url
      if controller.present?
        { :controller => "refinery/admin/#{controller}" }
      elsif directory.present?
        { :controller => "refinery/admin/#{directory.split('/').pop}" }
      else
        { :controller => "refinery/admin/#{name}" }
      end
    end
  end
end
