module Refinery
  module Settings
    require 'refinery/settings/engine' if defined?(Rails)
    require 'refinery/generators/settings_generator'

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end
  end
end
