# Before the application gets setup this will fail badly if there's no database.
=begin
# Set up middleware to serve theme files
config.middleware.use "ThemeServer"

::Refinery::ApplicationController.module_eval do

  # Add or remove theme paths to/from Refinery application
  before_filter do |controller|
    # remove any paths relating to any theme.
    controller.view_paths.reject! { |v| v.to_s =~ %r{^themes/} }

    # add back theme paths if there is a theme present.
    if (theme = Theme.current_theme(controller.request.env)).present?
      # Set up view path again for the current theme.
      controller.view_paths.unshift Rails.root.join("themes", theme, "views").to_s

      # Ensure that routes within the application are top priority.
      # Here we grab all the routes that are under the application's view folder
      # and promote them ahead of any other path.
      controller.view_paths.select{|p| p.to_s =~ /^app\/views/}.each do |app_path|
        controller.view_paths.unshift app_path
      end
    end

    # Set up menu caching for this theme or lack thereof
    RefinerySetting[:refinery_menu_cache_action_suffix] = "#{"#{theme}_" if theme.present?}site_menu" if RefinerySetting.table_exists?
  end

end

# Include theme functions into application helper.
Refinery::ApplicationHelper.send :include, ThemesHelper
=end
