module Refinery
  module Admin
    module PluginHelper
      def current_plugin_title
        Refinery::Plugin.current(params).try(:title)
      end
    end
  end
end
