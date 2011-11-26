require 'refinerycms-core'

module Refinery
  module <%= class_name.pluralize %><%= 'Engine' if plural_name == singular_name %>
    require 'refinery/<%= plural_name %>/engine' if defined?(Rails)

    class << self
      def table_name_prefix
        'refinery_'
      end

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end
  end
end
