require 'refinerycms-core'

module Refinery
  module Dashboard
    require 'refinery/dashboard/engine' if defined?(Rails)

    include ActiveSupport::Configurable

    config_accessor :activity_show_limit

    self.activity_show_limit = 7

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
