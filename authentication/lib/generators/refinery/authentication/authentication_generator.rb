module Refinery
  class AuthenticationGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def rake_db
      rake "refinery_authentication:install:migrations"
    end

    def generate_authentication_initializer
      template "config/initializers/refinery/authentication.rb.erb",
               File.join(destination_root, "config", "initializers", "refinery", "authentication.rb")
    end
  end
end
