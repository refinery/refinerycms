module Refinery
  class TestingGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def rake_db
      rake "refinery_testing:install:migrations"
    end

    def copy_guardfile
      template "Guardfile"
    end

    def copy_spec_helper
      directory "spec"
    end

  end
end
