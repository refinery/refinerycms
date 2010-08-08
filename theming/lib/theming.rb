# Before the application gets setup this will fail badly if there's no database.
require File.expand_path('../theme_server', __FILE__)

module Refinery
  class ThemingEngine < ::Rails::Engine

    config.to_prepare do
      ::Refinery::ApplicationController.module_eval do

        # Add or remove theme paths to/from Refinery application
        prepend_before_filter :attach_theme_to_refinery

        def attach_theme_to_refinery
          # remove any paths relating to any theme.
          view_paths.reject! { |v| v.to_s =~ %r{^themes/} }

          # add back theme paths if there is a theme present.
          if (theme = ::Theme.current_theme(request.env)).present?
            # Set up view path again for the current theme.
            view_paths.unshift Rails.root.join("themes", theme, "views").to_s

            # Ensure that routes within the application are top priority.
            # Here we grab all the routes that are under the application's view folder
            # and promote them ahead of any other path.
            view_paths.select{|p| p.to_s =~ /^app\/views/}.each do |app_path|
              view_paths.unshift app_path
            end
          end

          # Set up menu caching for this theme or lack thereof
          if RefinerySetting.table_exists? and
             RefinerySetting[:refinery_menu_cache_action_suffix] != (suffix = "#{"#{theme}_" if theme.present?}site_menu")
            RefinerySetting[:refinery_menu_cache_action_suffix] = suffix
          end
        end
        protected :attach_theme_to_refinery

      end

      ::ApplicationHelper.send :include, ::ThemesHelper
    end
    
    initializer 'themes.middleware' do |app|      
      app.config.middleware.insert_before ::ActionDispatch::Static, ::Refinery::ThemeServer
    end

  end
end
