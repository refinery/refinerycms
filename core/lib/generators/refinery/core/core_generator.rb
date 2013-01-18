module Refinery
  class CoreGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_refinery_initializer
      template "config/initializers/refinery/core.rb.erb",
               File.join(destination_root, "config", "initializers", "refinery", "core.rb")
    end
  end
end
