require 'refinerycms-core'
require 'rails'

module Refinery
  module Core
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace ::Refinery
      engine_name :refinery_core

      class << self
        def load_decorators
          Dir.glob(File.join(Rails.root, "app/decorators/**/*_decorator.rb")) do |c|
            Rails.application.config.cache_classes ? require(c) : load(c)
          end
        end

        # Performs the Refinery inclusion process which extends the currently loaded Rails
        # applications with Refinery's controllers and helpers. The process is wrapped by
        # a before_inclusion and after_inclusion step that calls procs registered by the
        # Refinery::Engine#before_inclusion and Refinery::Engine#after_inclusion class methods
        def refinery_inclusion!
          before_inclusion_procs.each(&:call)

          ::ApplicationHelper.send :include, ::Refinery::Helpers

          [::ApplicationController, ::Refinery::AdminController].each do |c|
            c.send :include, Refinery::ApplicationController
            c.send :helper, :application
          end

          Refinery::AdminController.send :include, Refinery::Admin::BaseController

          after_inclusion_procs.each(&:call)
        end
      end

      config.autoload_paths += %W( #{config.root}/lib )

      # Include the refinery controllers and helpers dynamically
      config.to_prepare &method(:refinery_inclusion!).to_proc

      after_inclusion &method(:load_decorators).to_proc

      # Wrap errors in spans
      config.to_prepare do
        ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
          "<span class=\"fieldWithErrors\">#{html_tag}</span>".html_safe
        end
      end

      initializer "refinery.will_paginate" do
        WillPaginate.per_page = 20
      end
      
      initializer "register refinery_core plugin", :after => :set_routes_reloader do |app|
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_core'
          plugin.class_name = 'RefineryEngine'
          plugin.version = Refinery.version
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /refinery\/(refinery_core)$/
        end
      end
      
      initializer "register refinery_dialogs plugin", :after => :set_routes_reloader do |app|
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_dialogs'
          plugin.version = Refinery.version
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /refinery\/(refinery_)?dialogs/
        end
      end

      initializer "refinery.configuration" do |app|
        app.config.refinery = Refinery::Configuration.new
      end

      initializer "refinery.routes" do |app|
        app.routes_reloader.paths << File.expand_path('../../catch_all_routes.rb', __FILE__)
      end

      initializer "refinery.autoload_paths" do |app|
        app.config.autoload_paths += [
          Rails.root.join('app', 'presenters'),
          Rails.root.join('vendor', '**', '**', 'app', 'presenters'),
          Refinery.roots.map{|r| r.join('**', 'app', 'presenters')}
        ].flatten
      end

      initializer "refinery.acts_as_indexed" do
        ActsAsIndexed.configure do |config|
          config.index_file = Rails.root.join('tmp', 'index')
          config.index_file_depth = 3
          config.min_word_size = 3
        end
      end

      # set the manifests and assets to be precompiled
      initializer "refinery.assets.precompile" do |app|
        app.config.assets.precompile += [
          "refinery/*",
          "refinery/icons/*",
          "wymeditor/lang/*",
          "wymeditor/skins/refinery/*",
          "wymeditor/skins/refinery/**/*",
          "modernizr-min.js",
          "dd_belatedpng.js"
        ]
      end

      # Disable asset debugging - it's a performance killer in dev mode
      initializer "refinery.assets.pipeline" do |app|
        app.config.assets.debug = false
      end

      # active model fields which may contain sensitive data to filter
      initializer "refinery.params.filter" do |app|
        app.config.filter_parameters += [:password, :password_confirmation]
      end

      initializer "refinery.encoding" do |app|
        app.config.encoding = 'utf-8'
      end

      initializer "refinery.memory_store" do |app|
        app.config.cache_store = :memory_store
      end
      
      config.after_initialize do
        Refinery.register_engine(Refinery::Core)
      end
    end
  end
end
