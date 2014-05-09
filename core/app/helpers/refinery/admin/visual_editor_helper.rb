module Refinery
  module Admin
    module VisualEditorHelper
      def visual_editor_javascripts
        Refinery::Core.visual_editor_javascripts.uniq
      end

      def visual_editor_stylesheets
        Refinery::Core.visual_editor_stylesheets.uniq(&:path)
      end
    end
  end
end
