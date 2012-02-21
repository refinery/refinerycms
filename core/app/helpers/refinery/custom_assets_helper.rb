module Refinery
  module CustomAssetsHelper
    def custom_javascripts
      ::Refinery::Core.javascripts
    end

    def custom_stylesheets
      ::Refinery::Core.stylesheets
    end
  end
end
