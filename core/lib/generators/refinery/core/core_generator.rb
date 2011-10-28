module Refinery
  class CoreGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_refinery_initializer
      template "config/initializers/refinery.rb.erb", File.join(destination_root, "config", "initializers", "refinery.rb")
    end
  end
end
