module Refinery
  module Admin
    module PagesHelper
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

        meta_information << content_tag(:span, :class => 'label') do
          ::I18n.t('skip_to_first_child', :scope => 'refinery.admin.pages.page')
        end if page.skip_to_first_child?

        meta_information << content_tag(:span, :class => 'label') do
          ::I18n.t('redirected', :scope => 'refinery.admin.pages.page')
        end if page.link_url?

        meta_information << content_tag(:span, :class => 'label notice') do
          ::I18n.t('draft', :scope => 'refinery.admin.pages.page')
        end if page.draft?

        meta_information
      end
    end
  end
end
