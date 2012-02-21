module Refinery
  class ResourcesGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_resources_initializer
      template "config/initializers/refinery/resources.rb.erb", File.join(destination_root, "config", "initializers", "refinery", "resources.rb")
    end

  end
end
