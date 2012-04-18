require 'refinerycms-core'

module Refinery
  autoload :PagesGenerator, 'generators/refinery/pages/pages_generator'

  module Pages
    require 'refinery/pages/engine'
    require 'refinery/pages/tab'
    require 'refinery/pages/type'
    require 'refinery/pages/types'

    # Load configuration last so that everything above is available to it.
    require 'refinery/pages/configuration'

    autoload :InstanceMethods, 'refinery/pages/instance_methods'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end

      def valid_templates(*pattern)
        [Rails.root, Refinery::Plugins.registered.pathnames].flatten.uniq.map { |p|
          p.join(*pattern)
        }.map(&:to_s).map { |p|
          Dir[p]
        }.select(&:any?).flatten.map { |f|
          File.basename(f)
        }.map { |p|
          p.split('.').first
        }
      end

      def default_parts_for(page)
        return default_parts unless page.view_template.present?

        types.find_by_name(page.view_template).parts.map &:titleize
      end
    end

    module Admin
      autoload :InstanceMethods, 'refinery/pages/admin/instance_methods'
    end
  end
end

ActiveSupport.on_load(:active_record) do
  require 'awesome_nested_set'
  require 'globalize3'
end
require 'friendly_id'
require 'seo_meta'
require 'babosa'
