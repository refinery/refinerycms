require 'refinerycms-core'

module Refinery
  module Dashboard
    require 'refinery/dashboard/engine' if defined?(Rails)

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
