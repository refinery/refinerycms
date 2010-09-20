require 'refinery'
require 'awesome_nested_set'

module Refinery
  module Pages
    class Engine < Rails::Engine

      # Register cache sweeper, ensuring that we don't overwrite any other observers.
      config.autoload_paths += %W(#{config.root}/app/sweepers)
      (config.active_record.observers ||= []) << :page_sweeper

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_pages"
          plugin.directory = "pages"
          plugin.version = %q{0.9.8}
          plugin.menu_match = /(refinery|admin)\/page(_part)?s(_dialogs)?$/
          plugin.activity = {
            :class => Page,
            :url_prefix => "edit",
            :title => "title",
            :created_image => "page_add.png",
            :updated_image => "page_edit.png"
          }
        end
      end

      initializer 'add marketable routes' do |app|
        app.routes_reloader.paths << File.expand_path('../pages/marketable_routes.rb', __FILE__)
      end

    end
  end
end
