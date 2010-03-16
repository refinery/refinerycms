# Before the application gets setup this will fail badly if there's no database.
if RefinerySetting.table_exists?
  # Set up middleware to serve theme files
  config.middleware.use "ThemeServer"

  # Add or remove theme paths to/from Refinery application
  ::Refinery::ApplicationController.module_eval do
    before_filter do |controller|
      # remove any paths relating to any theme.
      controller.view_paths.reject! { |v| v.to_s =~ %r{^themes/} }

      # add back theme paths if there is a theme present.
      if (theme = RefinerySetting[:theme]).present?
        # Set up view path again for the current theme.
        controller.view_paths.unshift Rails.root.join("themes", theme, "views").to_s
      end

      # Set up menu caching for this theme or lack thereof
      RefinerySetting[:refinery_menu_cache_action_suffix] = "#{"#{theme}_" if theme.present?}site_menu"

      # Ensure that routes within the application are top priority.
      # Here we grab all the routes that are under the application's view folder
      # and promote them ahead of any other path.
      controller.view_paths.select{|p| p.to_s =~ /^app\/views/}.each do |app_path|
        controller.view_paths.unshift app_path
      end

      # Ensure no duplicate paths.
      controller.view_paths.uniq!
    end
  end

  if (theme = RefinerySetting[:theme]).present?
    # Set up controller paths, which can only be brought in with a server restart, sorry. (But for good reason)
    controller_path = Rails.root.join("themes", theme, "controllers").to_s

    ::ActiveSupport::Dependencies.load_paths.unshift controller_path
    config.controller_paths.unshift controller_path
  end

  # Include theme functions into application helper.
  Refinery::ApplicationHelper.send :include, ThemesHelper
end
