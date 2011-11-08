module Refinery
  class <%= class_name.pluralize %>Generator < Rails::Generators::Base
    def rake_db
      rake("refinery_<%= plural_name %>:install:migrations")
    end
  end
end
