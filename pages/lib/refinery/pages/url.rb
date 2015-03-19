module Refinery
  module Pages
    class Url

      class Localised < Url
        def self.handle?(page)
          page.link_url.present?
        end

        def url
          current_url = page.link_url
          # Don't mess around with absolute URLs, just accept them.  Examples:
          #
          # * https://github.com/parndt
          # * http://github.com/parndt
          # * //github.com/parndt
          return current_url if current_url =~ %r{\A(https?:)?//}

          if Refinery::I18n.url_filter_enabled? && current_url =~ %r{^/} &&
            Refinery::I18n.current_frontend_locale != Refinery::I18n.default_frontend_locale
            current_url = "/#{Refinery::I18n.current_frontend_locale}#{current_url}"
          end

          # See https://github.com/refinery/refinerycms/issues/2740
          if current_url == '/'
            Refinery::Core.mounted_path
          else
            [Refinery::Core.mounted_path, current_url.sub(%r{\A/}, '')].
              join("/").sub("//", "/").sub(%r{/\z}, '')
          end
        end
      end

      class Marketable < Url
        def self.handle?(page)
          Refinery::Pages.marketable_urls
        end

        def url
          url_hash = base_url_hash.merge(:path => page.nested_url, :id => nil)
          with_locale_param(url_hash)
        end
      end

      class Normal < Url
        def self.handle?(page)
          page.to_param.present?
        end

        def url
          url_hash = base_url_hash.merge(:path => nil, :id => page.to_param)
          with_locale_param(url_hash)
        end
      end

      def self.build(page)
        klass = [ Localised, Marketable, Normal ].detect { |d| d.handle?(page) } || self
        klass.new(page).url
      end

      def initialize(page)
        @page = page
      end

      def url
        raise NotImplementedError
      end

      private

      attr_reader :page

      def with_locale_param(url_hash)
        if (locale = Refinery::I18n.current_frontend_locale) != ::I18n.locale
          url_hash.update :locale => locale if locale
        end
        url_hash
      end

      def base_url_hash
        { :controller => '/refinery/pages', :action => 'show', :only_path => true }
      end

    end
  end
end
