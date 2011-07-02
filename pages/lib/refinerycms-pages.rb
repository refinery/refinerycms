require 'refinerycms-core'
require 'awesome_nested_set'
require 'globalize3'
require 'friendly_id'
require 'seo_meta'

module Refinery
  module Pages

    autoload :InstanceMethods, File.expand_path('../refinery/pages/instance_methods', __FILE__)
    module Admin
      autoload :InstanceMethods, File.expand_path('../refinery/pages/admin/instance_methods', __FILE__)
    end

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      config.to_prepare do
        require File.expand_path('../pages/tabs', __FILE__)
      end

      refinery.after_inclusion do
        ::ApplicationController.send :include, ::Refinery::Pages::InstanceMethods
        ::Admin::BaseController.send :include, ::Refinery::Pages::Admin::InstanceMethods
      end

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_pages'
          plugin.directory = 'pages'
          plugin.version = %q{1.1.0}
          plugin.menu_match = /(refinery|admin)\/page(_part)?s(_dialogs)?$/
          plugin.url = app.routes.url_helpers.refinery_admin_pages_path
          plugin.activity = {
            :class => ::Refinery::Page,
            :url_prefix => "edit",
            :title => "title",
            :created_image => "page_add.png",
            :updated_image => "page_edit.png"
          }
        end
      end

      initializer 'add marketable routes' do |app|
        require File.expand_path('../pages/marketable_routes.rb', __FILE__)
        app.routes_reloader.paths << File.expand_path('../pages/marketable_routes.rb', __FILE__)
      end

    end
  end
end

::Refinery.engines << 'pages'
