module Refinery
  module Pages
    include ActiveSupport::Configurable

    config_accessor :pages_per_dialog, :pages_per_admin_index, :new_page_parts,
                    :marketable_urls, :approximate_ascii, :strip_non_ascii,
                    :default_parts, :use_custom_slugs, :scope_slug_by_parent,
                    :cache_pages_full, :layout_template_whitelist,
                    :use_layout_templates, :page_title, :absolute_page_links, :types,
                    :auto_expand_admin_tree, :show_title_in_body,
                    :friendly_id_reserved_words, :layout_templates_pattern, :view_templates_pattern,
                    :add_whitelist_elements, :add_whitelist_attributes, :whitelist_elements, :whitelist_attributes

    self.pages_per_dialog = 14
    self.pages_per_admin_index = 20
    self.new_page_parts = false
    self.marketable_urls = true
    self.approximate_ascii = false
    self.strip_non_ascii = false
    self.default_parts = [{ title: "Body", slug: "body" }, { title: "Side Body", slug: "side_body" }]
    self.use_custom_slugs = false
    self.scope_slug_by_parent = true
    self.cache_pages_full = false
    self.layout_template_whitelist = ["application"]
    self.add_whitelist_elements = %w[ source track ]
    # Note: "data-" attributes are whitelisted by default. See https://github.com/refinery/refinerycms/pull/3187
    self.add_whitelist_attributes = %w[ kind srclang placeholder controls required ]


    class << self
      def whitelist_elements
        Loofah::HTML5::WhiteList::ALLOWED_ELEMENTS.merge(config.add_whitelist_elements)
      end

      def whitelist_attributes
        Loofah::HTML5::WhiteList::ALLOWED_ATTRIBUTES.merge(config.add_whitelist_attributes)
      end

      def layout_template_whitelist
        Array(config.layout_template_whitelist).map(&:to_s)
      end
    end

    self.use_layout_templates = false
    self.page_title = {
      :chain_page_title => false,
      :ancestors => {
        :separator => " | ",
        :class => 'ancestors',
        :tag => 'span'
      },
      :page_title => {
        :class => nil,
        :tag => nil,
        :wrap_if_not_chained => false
      }
    }
    self.show_title_in_body = true
    self.absolute_page_links = false
    self.types = Types.registered
    self.auto_expand_admin_tree = true
    self.friendly_id_reserved_words = %w(
      index new session login logout users refinery admin images
    )
    self.layout_templates_pattern = 'app', 'views', '{layouts,refinery/layouts}', '*html*'
    self.view_templates_pattern = 'app', 'views', '{pages,refinery/pages}', '*html*'
  end
end
