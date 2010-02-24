# Set up middleware to serve theme files
config.middleware.use "ThemeServer"

# Add or remove theme paths to/from Refinery application
::Refinery::ApplicationController.module_eval %(
  before_filter do |controller|
    controller.view_paths.reject! { |v| v.to_s =~ %r{^themes/} }
    if (theme = RefinerySetting[:theme]).present?
      # Set up view path again for the current theme.
      controller.view_paths.unshift Rails.root.join("themes", theme, "views").to_s
    end
  end
)

# Set up controller paths, which can only be brought in with a server restart, sorry. (But for good reason)
controller_path = Rails.root.join("themes", RefinerySetting[:theme], "controllers").to_s

::ActiveSupport::Dependencies.load_paths.unshift controller_path
config.controller_paths.unshift controller_path

# Include theme functions into application helper.
Refinery::ApplicationHelper.send :include, ThemesHelper