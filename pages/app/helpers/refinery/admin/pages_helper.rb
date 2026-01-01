module Refinery
  module Admin
    module PagesHelper
      def parent_id_nested_set_options(current_page)
        pages = []
        nested_set_options(::Refinery::Page, current_page) { |page| pages << page }
        # page.title needs the :translations association, doing something like
        # nested_set_options(::Refinery::Page.includes(:translations), page) doesn't work, yet.
        # See https://github.com/collectiveidea/awesome_nested_set/pull/123
        if Rails::VERSION::MAJOR >= 7
          ActiveRecord::Associations::Preloader.new(records: pages, associations: :translations).call
        else
          ActiveRecord::Associations::Preloader.new.preload(pages, :translations)
        end
        pages.map { |page| ["#{'-' * page.level} #{page.title}", page.id] }
      end

      def template_options(template_type, current_page)
        html_options = { selected: send("default_#{template_type}", current_page) }

        if (template = current_page.send(template_type).presence)
          html_options.update selected: template
        elsif current_page.parent_id? && !current_page.send(template_type).presence
          template = current_page.parent.send(template_type).presence
          html_options.update selected: template if template
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

        tag.span meta_information, class: :meta
      end

      def page_icon(number_of_children)
        # 1. has_children 'folder|folderopen', 'toggle'
        # 2. no_children 'page'

        # .toggle scss handles adding icons to pages with children
        classes = ['icon']
        if number_of_children.zero?
          classes.push icon_class('page')
          title = ::I18n.t('edit', scope: 'refinery.admin.pages.page')
        else
          expanded_class = Refinery::Pages.auto_expand_admin_tree ? 'expanded' : ''
          classes.push 'toggle', expanded_class
          title = ::I18n.t('expand_collapse', scope: 'refinery.admin.pages')
        end

        tag.span(class: classes.join(' '), title: title)
      end
    end
  end
end
