module Refinery
  module Admin
    module PagesHelper
      def parent_id_nested_set_options(current_page)
        pages = []
        nested_set_options(::Refinery::Page, current_page) {|page| pages << page}
        # page.title needs the :translations association, doing something like
        # nested_set_options(::Refinery::Page.includes(:translations), page) doesn't work, yet.
        # See https://github.com/collectiveidea/awesome_nested_set/pull/123
        ActiveRecord::Associations::Preloader.new.preload(pages, :translations)
        pages.map {|page| ["#{'-' * page.level} #{page.title}", page.id]}
      end

      def template_options(template_type, current_page)
        html_options = { :selected => send("default_#{template_type}", current_page) }

        if (template = current_page.send(template_type).presence)
          html_options.update :selected => template
        elsif current_page.parent_id? && !current_page.send(template_type).presence
          template = current_page.parent.send(template_type).presence
          html_options.update :selected => template if template
        end

        html_options
      end

      def default_view_template(current_page)
        current_page.link_url == "/" ? "home" : "show"
      end

      def default_layout_template(current_page)
        "application"
      end

      # In the admin area we use a slightly different title
      # to inform the which pages are draft or hidden pages
      def page_meta_information(page)
        meta_information = ActiveSupport::SafeBuffer.new
        meta_information << content_tag(:span, :class => 'label') do
          ::I18n.t('hidden', :scope => 'refinery.admin.pages.page')
        end unless page.show_in_menu?

        meta_information << content_tag(:span, :class => 'label notice') do
          ::I18n.t('draft', :scope => 'refinery.admin.pages.page')
        end if page.draft?

        meta_information
      end

      # We show the title from the next available locale
      # if there is no title for the current locale
      def page_title_with_translations(page)
        page.title.presence || page.translations.detect {|t| t.title.present?}.title
      end

      def render_page_options(form)
        # add a toggle option for each plugin that has registered a page menu
        # save as draft is included with the links
        titles = ['Page', 'SEO']
        templates = ['form_advanced_options', 'form_advanced_seo']
        Refinery::Plugins.registered.each do |p|
          if p.options_template
            titles.push  p.plugin_activity ? p.plugin_activity.first.class_name.demodulize : p.name
            templates.push p.options_template
          end
        end
        links = render 'form_page_option_links',   {titles: titles, f:form}
        tabs =  render 'form_page_option_section', {templates: templates, f:form}
        return links << tabs
      end

      def page_part_controls
        content_tag(:ul, id: 'page_parts_controls') do
          content_tag(:li, link_to(refinery_icon_tag('arrow_switch.png'), '#', id: 'reorder_page_part', title: t('.reorder_content_section')))<<
          content_tag(:li, link_to(refinery_icon_tag('tick.png'), '#', id: 'reorder_page_part_done', title: t('.reorder_content_section_done')))<<
          content_tag(:li, link_to(refinery_icon_tag('add.png'), '#', id: 'add_page_part', title: t('.create_content_section')))<<
          content_tag(:li, link_to(refinery_icon_tag('delete.png'), '#', id: 'delete_page_part', title: t('.delete_content_section')))
        end
       end

      def page_tabs_and_editors(page, form)
        tabs = page.parts.each_with_index.map do
          |part, index| {
            title: part.title.titleize,
            id: part.id,
            template: part.edit_page_template,
            anchor: part.to_param,
            content: part.body}
        end

        tabs += ::Refinery::Pages.tabs_for_template(page.view_template).each_with_index.map do
             |tab, index| {
               title: tab.name.titleize,
               template: tab.partial,
               anchor:  "#custom_tab_#{index}",
               content: '' }
        end

        content_tag(:div, id: 'page-tabs', class: 'clearfix') do
          tab_index(tabs) << tab_editors(tabs, form)
        end
      end

      def tab_index(tabs)
        content_tag(:ul, id: 'page_parts') do
          tabs.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (tab, ix)|
            buffer << content_tag(:li, link_to(tab[:title], anchor: tab[:anchor]), data: {index: ix})
          end
        end
      end

      def page_part_attributes_fields(id, title, index, new_part=false)
        hidden_field_tag( "page[parts_attributes][#{index}][position]", index) +
        hidden_field_tag( "page[parts_attributes][#{index}][id]", id) +
        hidden_field_tag( "page[parts_attributes][#{index}][title]", title)
      end

      def new_page_part(form, title, body, index)
        part = ::Refinery::PagePart.new(title: title, body: body, plugin: 'refinery_pages')
        tab = {
          title: title.titleize,
          template: part.edit_page_template,
          anchor: "page_part_new_#{index}",
          content: body}
        Rails.logger.debug tab
        tab_field(form, tab, index, true)
      end

      def tab_field(form, tab, index, new_part=false)
        content_tag(:div, class: 'page_part', id: tab[:anchor]) do
          page_part_attributes_fields(tab[:id], tab[:title], index) << render( tab[:template], f: form, body: tab[:content], index: index)
        end
      end

      def tab_editors(tabs, form)
        content_tag(:div, id: 'page_part_editors') do
          tabs.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (tab, ix)|
            buffer << tab_field(form, tab, ix)
          end
        end
      end

    end
  end
end
