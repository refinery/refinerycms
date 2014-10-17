module Refinery
  module SiteBarHelper

    # Generates the link to determine where the site bar switch button returns to.
    def site_bar_switch_link
      if admin?
        link_to t('.switch_to_your_website', site_bar_translate_locale_args),
                refinery.root_path(site_bar_translate_locale_args),
                class: "button",
                'data-no-turbolink' => true
      else
        link_to t('.switch_to_your_website_editor', site_bar_translate_locale_args),
                refinery.admin_root_path,
                class: "button",
                'data-no-turbolink' => true
      end
    end

    def site_bar_translate_locale_args
      { :locale => Refinery::I18n.current_locale }
    end

  end
end
