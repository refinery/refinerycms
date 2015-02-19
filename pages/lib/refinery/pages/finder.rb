module Refinery
  module Pages
    class Finder
      def self.by_path(path)
        FinderByPath.new(path).find
      end

      def self.by_path_or_id(path, id)
        FinderByPathOrId.new(path, id).find
      end

      def self.by_title(title)
        FinderByTitle.new(title).find
      end

      def self.by_slug(slug, conditions = {})
        FinderBySlug.new(slug, conditions).find
      end

      def self.with_globalize(conditions = {})
        Finder.new(conditions).find
      end

      def initialize(conditions)
        @conditions = conditions
      end

      def find
        with_globalize
      end

      def with_globalize
        globalized_conditions = {:locale => ::Globalize.locale.to_s}.merge(conditions)
        translations_conditions = translations_conditions(globalized_conditions)

        # A join implies readonly which we don't really want.
        Page.where(globalized_conditions).
             joins(:translations).
             where(translations_conditions).
             readonly(false)
      end

      private
      attr_accessor :conditions

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

    class FinderByTitle < Finder
      def initialize(title)
        @title = title
        @conditions = default_conditions
      end

      def default_conditions
        { :title => title }
      end

      private
      attr_accessor :title
    end

    class FinderBySlug < Finder
      def initialize(slug, conditions)
        @slug = slug
        @conditions = default_conditions.merge(conditions)
      end

      def default_conditions
        {
          :locale => Refinery::I18n.frontend_locales.map(&:to_s),
          :slug => slug
        }
      end

      private
      attr_accessor :slug
    end

    class FinderByPath
      def initialize(path)
        @path = path
      end

      def find
        if slugs_scoped_by_parent?
          FinderByScopedPath.new(path).find
        else
          FinderByUnscopedPath.new(path).find
        end
      end

      private
      attr_accessor :path

      def slugs_scoped_by_parent?
        ::Refinery::Pages.scope_slug_by_parent
      end

      def by_slug(slug_path, conditions = {})
        Finder.by_slug(slug_path, conditions)
      end
    end

    class FinderByScopedPath < FinderByPath
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
          by_slug(parent_page_segment, :parent_id => nil).first
        else
          Page.find(parent_page_segment)
        end
      end

      def next_page(page)
        slug_or_id = path_segments.shift
        page.children.by_slug(slug_or_id).first || page.children.find(slug_or_id)
      end
    end

    class FinderByUnscopedPath < FinderByPath
      def find
        by_slug(path).first
      end
    end

    class FinderByPathOrId
      def initialize(path, id)
        @path = path
        @id = id
      end

      def find
        if path.present?
          if path.friendly_id?
            FinderByPath.new(path).find
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
