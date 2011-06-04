require 'refinerycms-core'
require 'rspec-rails'

module Refinery
  module Testing

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < ::Rails::Engine

      initializer 'serve static assets' do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.before_configuration do
        ::Refinery::Application.module_eval do
          def load_tasks
            super

            # To get specs from all Refinery engines, not just those in Rails.root/spec/
            ::RSpec::Core::RakeTask.module_eval do
              def pattern
                [@pattern] | ::Refinery::Plugins.registered.pathnames.map{|p|
                               p.join('spec', '**', '*_spec.rb').to_s
                             }
              end
            end if defined?(::RSpec::Core::RakeTask)
          end
        end
      end

      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinerycms_testing_plugin'
          plugin.version = ::Refinery.version
          plugin.hide_from_menu = true
        end
      end
    end

  end
end

::Refinery.engines << 'testing'
