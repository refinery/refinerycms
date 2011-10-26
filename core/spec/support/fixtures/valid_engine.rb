module Refinery
  module ValidEngine

    class << self
      def root
        Pathname.new File.expand_path("../", __FILE__)
      end
    end

    class Engine < Rails::Engine
    end
  end
end
