module Refinery
  class PageFinder
    # Find page by path, checking for scoping rules
    def self.find_by_path(path)
      return by_slug(path).first unless ::Refinery::Pages.scope_slug_by_parent

      # With slugs scoped to the parent page we need to find a page by its full path.
      # For example with about/example we would need to find 'about' and then its child
      # called 'example' otherwise it may clash with another page called /example.
      path = path.split('/').select(&:present?)
      page = by_slug(path.shift, :parent_id => nil).first
      while page && path.any? do
        slug_or_id = path.shift
        page = page.children.by_slug(slug_or_id).first || page.children.find(slug_or_id)
      end
      page
    end
    
    # Helps to resolve the situation where you have a path and an id
    # and if the path is unfriendly then a different finder method is required
    # than find_by_path.
    def self.find_by_path_or_id(path, id)
      if path.present?
        if path.friendly_id?
          Page.friendly.find_by_path(path)
        else
          Page.friendly.find(path)
        end
      elsif id.present?
        Page.friendly.find(id)
      end
    end

    # Finds pages by their title.  This method is necessary because pages
    # are translated which means the title attribute does not exist on the
    # pages table thus requiring us to find the attribute on the translations table
    # and then join to the pages table again to return the associated record.
    def self.by_title(title)
      with_globalize(:title => title)
    end

    # Finds pages by their slug.  This method is necessary because pages
    # are translated which means the slug attribute does not exist on the
    # pages table thus requiring us to find the attribute on the translations table
    # and then join to the pages table again to return the associated record.
    def self.by_slug(slug, conditions={})
      with_globalize({
        :locale => Refinery::I18n.frontend_locales.map(&:to_s),
        :slug => slug
      }.merge(conditions))
    end
    
    # Wrap up the logic of finding the pages based on the translations table.
    def self.with_globalize(conditions = {})
      PageFinder.new.with_globalize(conditions)
    end

    def with_globalize(conditions)
      conditions = {:locale => ::Globalize.locale.to_s}.merge(conditions)
      translations_conditions = {}
      translated_attrs = Page.translated_attribute_names.map(&:to_s) | %w(locale)

      conditions.keys.each do |key|
        if translated_attrs.include? key.to_s
          translations_conditions["#{Page.translation_class.table_name}.#{key}"] = conditions.delete(key)
        end
      end

      # A join implies readonly which we don't really want.
      Page.where(conditions).joins(:translations).where(translations_conditions).
                                             readonly(false)
    end
  end
end