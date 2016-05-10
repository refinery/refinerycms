module Refinery
  module Admin
    module PagesHelper

      def sorted_nested_li(objects, order, &block)
        nested_li sort_list(objects, order), &block
      end

      def nested_li(objects, &block)
        objects = objects.order(:lft) if objects.is_a? Class

        return '' if objects.size == 0

        output = "<li class='clearfix record items' id='#{dom_id(objects.first)}' >"
        path = [nil]

        objects.each_with_index do |o, i|
          if o.parent_id != path.last
            # We are on a new level, did we descend or ascend?
            if path.include?(o.parent_id)
              # Remove the wrong trailing path elements
              while path.last != o.parent_id
                path.pop
                output << "</li></ul>"
              end
              output << "</li><li class='clearfix record items' id='#{dom_id(o)}' >"
            else
              path << o.parent_id
              output << "<ul class='nested' data-ajax-content='#{refinery.admin_children_pages_path(o.nested_url)}'><li class='clearfix record items' id='#{dom_id(o)}' >"
            end
          elsif i != 0
            output << "</li><li class='clearfix record items' id='#{dom_id(o)}' >"
          end
          output << capture(o, path.size - 1, &block)
        end

        output << '</li>' * path.length
        output.html_safe
      end

      def parent_id_nested_set_options(current_page)
        pages = []
        nested_set_options(::Refinery::Page, current_page) { |page| pages << page}
        # page.title needs the :translations association, doing something like
        # nested_set_options(::Refinery::Page.includes(:translations), page) doesn't work, yet.
        # See https://github.com/collectiveidea/awesome_nested_set/pull/123
        ActiveRecord::Associations::Preloader.new.preload(pages, :translations)
        pages.map { |page| ["#{'-' * page.level} #{page.title}", page.id]}
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
        Refinery.deprecate('page_title_with_translations', when: '3.1', replacement: 'translated_field')
        page.title.presence || page.translations.detect { |t| t.title.present?}.title
      end

      private

      def sort_list(objects, order)
        objects = objects.order(:lft) if objects.is_a? Class

       # Partition the results
        children_of = {}
        objects.each do |o|
          children_of[ o.parent_id ] ||= []
          children_of[ o.parent_id ] << o
        end

        # Sort each sub-list individually
        children_of.each_value do |children|
          children.sort_by! &order
        end

        # Re-join them into a single list
        results = []
        recombine_lists(results, children_of, nil)

        results
      end

      def recombine_lists(results, children_of, parent_id)
        if children_of[parent_id]
          children_of[parent_id].each do |o|
            results << o
            recombine_lists(results, children_of, o.id)
          end
        end
      end

    end
  end
end
