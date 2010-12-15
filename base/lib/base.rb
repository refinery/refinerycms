require 'refinery'

module Refinery

  module Base
    class << self
    end

    class Engine < Rails::Engine

      config.autoload_paths += %W( #{config.root}/lib )

      config.before_configuration do
      end

      config.to_prepare do
      end

      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.name = "refinerycms_base"
          plugin.class_name ="RefineryBaseEngine"
          plugin.version = Refinery.version.to_s
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /(refinery|admin)\/(refinery_base)$/
        end
      end
    end
  end

end
