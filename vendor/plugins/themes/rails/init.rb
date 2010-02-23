Refinery::Plugin.register do |plugin|
  plugin.title = "Themes"
  plugin.description = "Upload and manage themes"
  plugin.version = 1.0
  plugin.activity = {
    :class => Theme,
    :title => 'title',
    :url_prefix => 'edit',
    :created_image => "layout_add.png",
    :updated_image => "layout_edit.png"
  }
end

config.middleware.use "ThemeServer"
::ActionController::Base.module_eval %(
  view_paths.unshift Rails.root.join("themes", RefinerySetting[:theme], "views").to_s if RefinerySetting[:theme].present?
)

# set up controller paths.
if RefinerySetting[:theme].present?
  controller_path = Rails.root.join("themes", RefinerySetting[:theme], "controllers").to_s

  ::ActiveSupport::Dependencies.load_paths.unshift controller_path
  config.controller_paths.unshift controller_path

  Refinery::ApplicationHelper.send :include, ThemesHelper
end