# Encoding: utf-8
require 'friendly_id'
require 'refinery/core/base_model'
require 'refinery/pages/url'
require 'refinery/page_finder'

module Refinery
  class Page < Core::BaseModel
    extend FriendlyId

    translates :title, :menu_title, :custom_slug, :slug, :include => :seo_meta

    class Translation
      is_seo_meta

      def self.seo_fields
        ::SeoMeta.attributes.keys.map{|a| [a, :"#{a}="]}.flatten
      end
    end

    class FriendlyIdOptions
      def self.reserved_words
        %w(index new session login logout users refinery admin images)
      end

      def self.options
        # Docs for friendly_id http://github.com/norman/friendly_id
        friendly_id_options = {
          use: [:reserved],
          reserved_words: self.reserved_words
        }
        if ::Refinery::Pages.scope_slug_by_parent
          friendly_id_options[:use] << :scoped
          friendly_id_options.merge!(scope: :parent)
        end
        friendly_id_options[:use] << :globalize
        friendly_id_options
      end
    end

    # If title changes tell friendly_id to regenerate slug when saving record
    def should_generate_new_friendly_id?
      changes.keys.include?("title")
    end

    # Delegate SEO Attributes to globalize translation
    delegate(*(Translation.seo_fields << {:to => :translation}))

    validates :title, :presence => true

    validates :custom_slug, :uniqueness => true, :allow_blank => true

    # Docs for acts_as_nested_set https://github.com/collectiveidea/awesome_nested_set
    # rather than :delete_all we want :destroy
    acts_as_nested_set :dependent => :destroy

    friendly_id :custom_slug_or_title, FriendlyIdOptions.options

    has_many :parts, -> {
      scope = order('position ASC')
      scope = scope.includes(:translations) if ::Refinery::PagePart.respond_to?(:translation_class)
      scope
    },       :foreign_key => :refinery_page_id,
             :class_name => '::Refinery::PagePart',
             :inverse_of => :page,
             :dependent => :destroy

    accepts_nested_attributes_for :parts, :allow_destroy => true

    before_destroy :deletable?
    after_save :reposition_parts!

    class << self
      # Live pages are 'allowed' to be shown in the frontend of your website.
      # By default, this is all pages that are not set as 'draft'.
      def live
        where(:draft => false)
      end

      # Find page by path, checking for scoping rules
      def find_by_path(path)
        ::Refinery::PageFinder.find_by_path(path)
      end

      # Helps to resolve the situation where you have a path and an id
      # and if the path is unfriendly then a different finder method is required
      # than find_by_path.
      def find_by_path_or_id(path, id)
        ::Refinery::PageFinder.find_by_path_or_id(path, id)
      end

      # Helps to resolve the situation where you have a path and an id
      # and if the path is unfriendly then a different finder method is required
      # than find_by_path.
      #
      # raise ActiveRecord::RecordNotFound if not found.
      def find_by_path_or_id!(path, id)
        page = find_by_path_or_id(path, id)

        raise ActiveRecord::RecordNotFound unless page

        page
      end

      # Finds pages by their title.  This method is necessary because pages
      # are translated which means the title attribute does not exist on the
      # pages table thus requiring us to find the attribute on the translations table
      # and then join to the pages table again to return the associated record.
      def by_title(title)
        ::Refinery::PageFinder.by_title(title)
      end

      # Finds pages by their slug.  This method is necessary because pages
      # are translated which means the slug attribute does not exist on the
      # pages table thus requiring us to find the attribute on the translations table
      # and then join to the pages table again to return the associated record.
      def by_slug(slug, conditions={})
        ::Refinery::PageFinder.by_slug(slug, conditions)
      end

      # Shows all pages with :show_in_menu set to true, but it also
      # rejects any page that has not been translated to the current locale.
      # This works using a query against the translated content first and then
      # using all of the page_ids we further filter against this model's table.
      def in_menu
        where(:show_in_menu => true).with_globalize
      end

      # An optimised scope containing only live pages ordered for display in a menu.
      def fast_menu
        live.in_menu.order(arel_table[:lft]).includes(:parent, :translations)
      end

      # Wrap up the logic of finding the pages based on the translations table.
      def with_globalize(conditions = {})
        ::Refinery::PageFinder.with_globalize(conditions)
      end

      # Returns how many pages per page should there be when paginating pages
      def per_page(dialog = false)
        dialog ? Pages.pages_per_dialog : Pages.pages_per_admin_index
      end

      def rebuild_with_slug_nullification!
        rebuild_without_slug_nullification!
        nullify_duplicate_slugs_under_the_same_parent!
      end
      alias_method_chain :rebuild!, :slug_nullification

      protected
      def nullify_duplicate_slugs_under_the_same_parent!
        t_slug = translation_class.arel_table[:slug]
        joins(:translations).group(:locale, :parent_id, t_slug).having(t_slug.count.gt(1)).count.
        each do |(locale, parent_id, slug), count|
          by_slug(slug, :locale => locale).where(:parent_id => parent_id).drop(1).each do |page|
            page.slug = nil # kill the duplicate slug
            page.save # regenerate the slug
          end
        end
      end
    end

    def translated_to_default_locale?
      persisted? && translations.any?{|t| t.locale == Refinery::I18n.default_frontend_locale}
    end

    # The canonical page for this particular page.
    # Consists of:
    #   * The default locale's translated slug
    def canonical
      Globalize.with_locale(::Refinery::I18n.default_frontend_locale) { url }
    end

    # The canonical slug for this particular page.
    # This is the slug for the default frontend locale.
    def canonical_slug
      Globalize.with_locale(::Refinery::I18n.default_frontend_locale) { slug }
    end

    # Returns in cascading order: custom_slug or menu_title or title depending on
    # which attribute is first found to be present for this page.
    def custom_slug_or_title
      custom_slug.presence || menu_title.presence || title.presence
    end

    # Am I allowed to delete this page?
    # If a link_url is set we don't want to break the link so we don't allow them to delete
    # If deletable is set to false then we don't allow this page to be deleted. These are often Refinery system pages
    def deletable?
      deletable && link_url.blank? && menu_match.blank?
    end

    # Repositions the child page_parts that belong to this page.
    # This ensures that they are in the correct 0,1,2,3,4... etc order.
    def reposition_parts!
      reload.parts.each_with_index do |part, index|
        part.update_columns position: index
      end
    end

    # Before destroying a page we check to see if it's a deletable page or not
    # Refinery system pages are not deletable.
    def destroy
      return super if deletable?

      puts_destroy_help

      false
    end

    # If you want to destroy a page that is set to be not deletable this is the way to do it.
    def destroy!
      self.update_attributes(:menu_match => nil, :link_url => nil, :deletable => true)

      self.destroy
    end

    # Used for the browser title to get the full path to this page
    # It automatically prints out this page title and all of it's parent page titles joined by a PATH_SEPARATOR
    def path(options = {})
      # Override default options with any supplied.
      options = {:reversed => true}.merge(options)

      if parent_id
        parts = [title, parent.path(options)]
        parts.reverse! if options[:reversed]
        parts.join(' - ')
      else
        title
      end
    end

    def url
      Pages::Url.build(self)
    end

    def nested_url
      globalized_slug = Globalize.with_locale(slug_locale) { to_param.to_s }
      if ::Refinery::Pages.scope_slug_by_parent
        [parent.try(:nested_url), globalized_slug].compact.flatten
      else
        [globalized_slug]
      end
    end

    # Returns an array with all ancestors to_param, allow with its own
    # Ex: with an About page and a Mission underneath,
    # ::Refinery::Page.find('mission').nested_url would return:
    #
    #   ['about', 'mission']
    #
    alias_method :uncached_nested_url, :nested_url

    # Returns the string version of nested_url, i.e., the path that should be
    # generated by the router
    def nested_path
      ['', nested_url].join('/')
    end

    # Returns true if this page is "published"
    def live?
      !draft?
    end

    # Return true if this page can be shown in the navigation.
    # If it's a draft or is set to not show in the menu it will return false.
    def in_menu?
      live? && show_in_menu?
    end

    def not_in_menu?
      !in_menu?
    end

    # Returns all visible sibling pages that can be rendered for the menu
    def shown_siblings
      siblings.reject(&:not_in_menu?)
    end

    def to_refinery_menu_item
      {
        :id => id,
        :lft => lft,
        :depth => depth,
        :menu_match => menu_match,
        :parent_id => parent_id,
        :rgt => rgt,
        :title => menu_title.presence || title.presence,
        :type => self.class.name,
        :url => url
      }
    end

    # Accessor method to get a page part from a page.
    # Example:
    #
    #    ::Refinery::Page.first.content_for(:body)
    #
    # Will return the body page part of the first page.
    def content_for(part_title)
      part_with_title(part_title).try(:body)
    end

    # Accessor method to test whether a page part
    # exists and has content for this page.
    # Example:
    #
    #   ::Refinery::Page.first.content_for?(:body)
    #
    # Will return true if the page has a body page part and it is not blank.
    def content_for?(part_title)
      content_for(part_title).present?
    end

    # Accessor method to get a page part object from a page.
    # Example:
    #
    #    ::Refinery::Page.first.part_with_title(:body)
    #
    # Will return the Refinery::PagePart object with that title using the first page.
    def part_with_title(part_title)
      # self.parts is usually already eager loaded so we can now just grab
      # the first element matching the title we specified.
      self.parts.detect do |part|
        part.title_matches?(part_title)
      end
    end

    private

    class FriendlyIdPath
      def self.normalize_friendly_id_path(slug_string)
        # Remove leading and trailing slashes, but allow internal
        slug_string
          .sub(%r{^/*}, '')
          .sub(%r{/*$}, '')
          .split('/')
          .select(&:present?)
          .map {|slug| self.normalize_friendly_id_with_marketable_urls(slug) }.join('/')
      end

      def self.normalize_friendly_id_with_marketable_urls(slug_string)
        # If we are scoping by parent, no slashes are allowed. Otherwise, slug is
        # potentially a custom slug that contains a custom route to the page.
        if !Pages.scope_slug_by_parent && slug_string.include?('/')
          self.normalize_friendly_id_path(slug_string)
        else
          self.protected_slug_string(slug_string)
        end
      end

      def self.protected_slug_string(slug_string)
        sluggified = slug_string.to_slug.normalize!
        sluggified << "-page" if Pages.marketable_urls && FriendlyIdOptions.reserved_words.include?(sluggified)
        sluggified
      end
    end

    # Protects generated slugs from title if they are in the list of reserved words
    # This applies mostly to plugin-generated pages.
    # This only kicks in when Refinery::Pages.marketable_urls is enabled.
    # Also check for global scoping, and if enabled, allow slashes in slug.
    #
    # Returns the sluggified string
    def normalize_friendly_id_with_marketable_urls(slug_string)
      FriendlyIdPath.normalize_friendly_id_with_marketable_urls(slug_string)
    end
    alias_method_chain :normalize_friendly_id, :marketable_urls

    def puts_destroy_help
      puts "This page is not deletable. Please use .destroy! if you really want it deleted "
      puts "unset .link_url," if link_url.present?
      puts "unset .menu_match," if menu_match.present?
      puts "set .deletable to true" unless deletable
    end

    def slug_locale
      return Globalize.locale if translation_for(Globalize.locale).try(:slug).present?

      if translations.empty? || translation_for(Refinery::I18n.default_frontend_locale).present?
        Refinery::I18n.default_frontend_locale
      else
        translations.first.locale
      end
    end
  end
end
