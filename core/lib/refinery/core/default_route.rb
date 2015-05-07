module Refinery
  module Core
    class DefaultRoute

      class << self
        def load
          Refinery::Core::Engine.routes.draw do
            namespace :admin, :path => Refinery::Core.backend_route do
              root :to => ::Refinery::Plugins.registered.in_menu.first.url
            end
          end
        end
      end
    end
  end
end
