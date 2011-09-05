require 'refinerycms-core'
require 'awesome_nested_set'
require 'globalize3'
require 'friendly_id'
require 'seo_meta'
require File.expand_path('../generators/pages_generator', __FILE__)

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

      def use_marketable_urls?
        ::Refinery::Setting.find_or_set(:use_marketable_urls, true, :scoping => 'pages')
      end

      def use_marketable_urls=(value)
        ::Refinery::Setting.set(:use_marketable_urls, {:value => value, :scoping => 'pages'})
      end
    end

    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      config.before_initialize do
        require File.expand_path('../pages/marketable_urls', __FILE__)
      end

      config.to_prepare do
        require File.expand_path('../pages/tabs', __FILE__)
        require File.expand_path('../pages/marketable_urls', __FILE__)
        ::Refinery::Page.translation_class.send(:is_seo_meta)
        # set allowed attributes for mass assignment
        ::Refinery::Page.translation_class.send :attr_accessible, :browser_title, :meta_description, :meta_keywords, :locale
      end

      refinery.after_inclusion do
        ::ApplicationController.send :include, ::Refinery::Pages::InstanceMethods
        ::Refinery::AdminController.send :include, ::Refinery::Pages::Admin::InstanceMethods
      end

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_pages'
          plugin.directory = 'pages'
          plugin.version = %q{2.0.0}
          plugin.menu_match = /refinery\/page(_part)?s(_dialogs)?$/
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

    end
  end
end

::Refinery.engines << 'pages'
