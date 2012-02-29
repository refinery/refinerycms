require 'refinerycms-core'

module Refinery
  autoload :<%= extension_plural_class_name %>Generator, 'generators/refinery/<%= extension_plural_name %>_generator'

  module <%= class_name.pluralize %><%= 'Engine' if plural_name == singular_name %>
    require 'refinery/<%= plural_name %>/engine'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
