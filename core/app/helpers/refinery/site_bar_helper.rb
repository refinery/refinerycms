module Refinery
  module SiteBarHelper

    # Generates the link to determine where the site bar switch button returns to.
    def site_bar_switch_link
      link_to_if(admin?, t('.switch_to_your_website', site_bar_translate_locale_args),
                         refinery.root_path(site_bar_translate_locale_args),
                         'data-turbolinks' => false) do
        link_to t('.switch_to_your_website_editor', site_bar_translate_locale_args),
                Refinery::Core.backend_path, 'data-turbolinks' => false
      end
    end

    def site_bar_edit_link
      return nil if admin? || @page.nil?
      link_to t('refinery.admin.pages.edit', site_bar_translate_locale_args),
              refinery.admin_edit_page_path(@page.nested_url,
              :switch_locale => (@page.translations.first.locale unless @page.translated_to_default_locale?)),
              'data-turbolinks' => false
    end

    def site_bar_translate_locale_args
      { :locale => Refinery::I18n.current_locale }
    end

    def display_site_bar?
      authorisation_manager.allow?(:read, :site_bar) &&
        "#{controller_name}##{action_name}" !~ %r{preview#show}
    end

  end
end
