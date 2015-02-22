module Refinery
  module Pages
    class Finder
      def initialize(scope: Page, locale: Globalize.locale.to_s, conditions: {})
        @scope = scope
        @conditions = conditions
      end

      class << self
        def by_path(path)
          Finders::Path.new(path: path).find
        end

        def by_path_or_id(path, id)
          Finders::PathOrId.new(path: path, id: id).find
        end

        def by_path_or_id!(path, id)
          by_path_or_id(path: path, id: id) || raise(ActiveRecord::RecordNotFound)
        end

        def by_title(title)
          Finders::Title.new(title).find
        end

        def by_slug(slug, conditions: {})
          Finders::Slug.new(slug, conditions: conditions).find
        end

        def with_globalize(conditions: {})
          Finder.new(conditions: conditions).find
        end
      end

      def with_globalize
        globalized_conditions = {:locale => locale}.merge(@conditions)
        translations_conditions = translations_conditions(globalized_conditions)

        # A join implies readonly which we don't really want.
        scope.where(globalized_conditions).joins(:translations)
             .where(translations_conditions).readonly(false)
      end
      alias_method :find, :with_globalize

      private
      attr_accessor :conditions, :locale, :scope

      def translated_attributes
        Page.translated_attribute_names.map(&:to_s) | %w(locale)
      end

      def translations_conditions(original_conditions)
        translations_conditions = {}
        original_conditions.keys.each do |key|
          if translated_attributes.include? key.to_s
            translations_conditions["#{Page.translation_class.table_name}.#{key}"] = original_conditions.delete(key)
          end
        end
        translations_conditions
      end
    end

    module Finders
      class Title < Finder
        def initialize(title)
          super
          @title = title
          @conditions = default_conditions
        end

        def default_conditions
          { :title => title }
        end

        private
        attr_accessor :title
      end

      class Slug < Finder
        def initialize(slug, locale: Refinery::I18n.frontend_locales.map(&:to_s))
          super(locale: locale, conditions: {slug: slug})
        end
      end

      class Path < Finder
        def initialize(scope: Page, conditions: {}, path:)
          super(scope: scope, conditions: conditions)
          @path = path
        end

        def find
          if slugs_scoped_by_parent?
            ScopedPath.new(path: path).find
          else
            UnscopedPath.new(path: path).find
          end
        end

        private
        attr_accessor :path

        def slugs_scoped_by_parent?
          ::Refinery::Pages.scope_slug_by_parent
        end

        delegate :by_slug, to: Finder
      end

      class ScopedPath < Finders::Path
        def find
          # With slugs scoped to the parent page we need to find a page by its full path.
          # For example with about/example we would need to find 'about' and then its child
          # called 'example' otherwise it may clash with another page called /example.
          page = parent_page
          while page && path_segments.any? do
            page = next_page(page)
          end
          page
        end

        private

        def path_segments
          @path_segments ||= path.split('/').select(&:present?)
        end

        def parent_page
          parent_page_segment = path_segments.shift
          if parent_page_segment.friendly_id?
            by_slug(parent_page_segment, conditions: {parent_id: nil}).first
          else
            Page.find(parent_page_segment)
          end
        end

        def next_page(page)
          slug_or_id = path_segments.shift
          page.children.by_slug(slug_or_id).first || page.children.find(slug_or_id)
        end
      end

      class UnscopedPath < Finders::Path
        def find
          by_slug(path).first
        end
      end

      class PathOrId < Finder
        def initialize(scope: Page, conditions: {}, path:, id:)
          super(scope: scope, conditions: conditions)
          @path = path
          @id = id
        end

        def find
          if path.present?
            if path.friendly_id?
              Path.new(path: path).find
            else
              Page.friendly.find(path)
            end
          elsif id.present?
            Page.friendly.find(id)
          end
        end

        private
        attr_accessor :id, :path
      end
    end
  end
end
