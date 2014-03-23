module Refinery
  module CustomAssetsHelper
    def custom_javascripts
      ::Refinery::Core.javascripts.uniq
    end

    def custom_stylesheets
      ::Refinery::Core.stylesheets.uniq(&:path)
    end
  end
end
