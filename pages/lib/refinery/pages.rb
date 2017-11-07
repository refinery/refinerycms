require 'refinerycms-core'
require 'globalize'

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
        ([Rails.root] | Refinery::Plugins.registered.pathnames).map { |p|
          Dir[p.join(*pattern).to_s].flatten.map do |f|
            File.basename(f).split('.').first
          end
        }.flatten.uniq
      end

      def default_parts_for(page)
        return default_parts unless page.view_template.present?

        types.find_by_name(page.view_template).parts.map(&:titleize)
      end
    end

    module Admin
      autoload :InstanceMethods, 'refinery/pages/admin/instance_methods'
    end
  end
end

ActiveSupport.on_load(:active_record) do
  require 'awesome_nested_set'
end
require 'friendly_id'
require 'seo_meta'
require 'babosa'
require 'speakingurl-rails'