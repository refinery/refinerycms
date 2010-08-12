require 'refinery'

module Refinery
  module Inquiries
    class Engine < Rails::Engine
      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.title = "Inquiries"
          plugin.name = "refinery_inquiries"
          plugin.directory = "inquiries"
          plugin.description = "Provides a contact form and stores inquiries"
          plugin.version = %q{0.9.8}
          plugin.menu_match = /(refinery|admin)\/inquir(ies|y_settings)$/
          plugin.activity = {
            :class => InquirySetting,
            :title => 'name'
          }
        end
      end
    end
  end
end
