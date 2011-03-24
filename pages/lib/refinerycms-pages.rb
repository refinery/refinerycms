require 'refinerycms-core'
require 'awesome_nested_set'
require 'globalize3'

module Refinery
  module Pages

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < ::Rails::Engine

      initializer "serve static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.to_prepare do
        require File.expand_path('../pages/tabs', __FILE__)
      end

      config.after_initialize do
        ::ApplicationController.module_eval do

          def error_404(exception=nil)
            if (@page = Page.where(:menu_match => "^/404$").includes(:parts, :slugs).first).present?
              # render the application's custom 404 page with layout and meta.
              render :template => "/pages/show",
                     :format => 'html',
                     :status => 404
            else
              super
            end
          end

          def find_pages_for_menu
            @menu_pages = Page.in_menu.live.order('lft ASC').includes(:slugs)
          end

        end

        ::Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_pages"
          plugin.directory = "pages"
          plugin.version = %q{0.9.9}
          plugin.menu_match = /(refinery|admin)\/page(_part)?s(_dialogs)?$/
          plugin.activity = {
            :class => Page,
            :url_prefix => "edit",
            :title => "title",
            :created_image => "page_add.png",
            :updated_image => "page_edit.png"
          }
        end
      end

      initializer 'add marketable routes' do |app|
        app.routes_reloader.paths << File.expand_path('../pages/marketable_routes.rb', __FILE__)
      end

    end
  end
end

::Refinery.engines << 'pages'
