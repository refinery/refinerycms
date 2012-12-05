module Refinery
  module Pages
    include ActiveSupport::Configurable

    config_accessor :pages_per_dialog, :pages_per_admin_index, :new_page_parts,
                    :marketable_urls, :approximate_ascii, :strip_non_ascii,
                    :default_parts, :use_custom_slugs, :cache_pages_backend,
                    :cache_pages_full, :layout_template_whitelist,
                    :view_template_whitelist, :use_layout_templates,
                    :use_view_templates, :page_title, :absolute_page_links, :types,
                    :auto_expand_admin_tree, :show_title_in_body

    self.pages_per_dialog = 14
    self.pages_per_admin_index = 20
    self.new_page_parts = false
    self.marketable_urls = true
    self.approximate_ascii = false
    self.strip_non_ascii = false
    self.default_parts = ["Body", "Side Body"]
    self.use_custom_slugs = false
    self.cache_pages_backend = false
    self.cache_pages_full = false
    self.layout_template_whitelist = ["application"]
    self.view_template_whitelist = ["home", "show"]
    self.use_layout_templates = false
    self.use_view_templates = false
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
  end
end
