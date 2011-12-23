require 'refinerycms-core'

module Refinery
  module Dashboard
    require 'refinery/dashboard/engine'
    require 'refinery/dashboard/configuration'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
