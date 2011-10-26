module Refinery
  class ImagesGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_images_initializer
      template "config/initializers/refinery_images.rb.erb", File.join(destination_root, "config", "initializers", "refinery_images.rb")
    end

  end
end
