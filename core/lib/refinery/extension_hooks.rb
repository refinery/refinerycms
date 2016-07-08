module Refinery
  class ExtensionHooks

    class << self
      @@paths = {html_partials: {}}

      def register_stylesheets(paths)
        (@@paths[:backend_stylesheets] ||= []).concat(paths)
      end

      def backend_stylesheets
        @@paths[:backend_stylesheets] || []
      end

      def register_js_files(paths)
        (@@paths[:backend_js_files] ||= []).concat(paths)
      end

      def backend_js_files
        @@paths[:backend_js_files] || []
      end

      def register_html_partials(paths, scope = :layout)
        (@@paths[:html_partials][scope] ||= []).concat(paths)
      end

      def html_partials(scope = :layout)
        @@paths[:html_partials][scope] || []
      end
    end
  end
end
