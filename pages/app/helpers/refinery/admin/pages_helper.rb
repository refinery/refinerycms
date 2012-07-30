module Refinery
  module Admin
    module PagesHelper
      def parent_id_nested_set_options(current_page)
        pages = []
        nested_set_options(::Refinery::Page, current_page) {|page| pages << page}
        # page.title needs the :translations association, doing something like
        # nested_set_options(::Refinery::Page.includes(:translations), page) doesn't work, yet.
        # See https://github.com/collectiveidea/awesome_nested_set/pull/123
        ActiveRecord::Associations::Preloader.new(pages, :translations).run
        pages.map {|page| ["#{'-' * page.level} #{page.title}", page.id]}
      end

      def template_options(template_type, current_page)
        return {} if current_page.send(template_type)

        if current_page.parent_id?
          # Use Parent Template by default.
          { :selected => current_page.parent.send(template_type) }
        else
          # Use Default Template (First in whitelist)
          { :selected => Refinery::Pages.send("#{template_type}_whitelist").first }
        end
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

        meta_information.html_safe
      end

      # We show the title from the next available locale
      # if there is no title for the current locale
      def page_title_with_translations(page)
        if page.title.present?
          page.title
        else
          page.translations.detect {|t| t.title.present?}.title
        end
      end
    end
  end
end
