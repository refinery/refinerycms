module Refinery
  module SiteBarHelper

    # Generates the link to determine where the site bar switch button returns to.
    def site_bar_switch_link
      link_to_if(admin?, t('.switch_to_your_website', site_bar_translate_locale_args),
                (if session.keys.map(&:to_sym).include?(:website_return_to) and session[:website_return_to].present?
                  session[:website_return_to]
                 else
                  refinery.root_path(:locale => (Refinery::I18n.default_frontend_locale if Refinery.i18n_enabled?))
                 end)) do
        link_to t('.switch_to_your_website_editor', site_bar_translate_locale_args),
                (if session.keys.map(&:to_sym).include?(:refinery_return_to) and session[:refinery_return_to].present?
                  session[:refinery_return_to]
                else
                  refinery.admin_root_path
                 end rescue refinery.admin_root_path)
      end
    end

    def site_bar_translate_locale_args
      if Refinery.i18n_enabled?
        { :locale => Refinery::I18n.current_locale }
      else
        {}
      end
    end

  end
end
