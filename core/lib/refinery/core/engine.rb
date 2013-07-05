module Refinery
  module Core
    class Engine < ::Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery

      class << self
        # Register all decorators from app/decorators/ and registered plugins' paths.
        def register_decorators!
          Decorators.register! Rails.root, Refinery::Plugins.registered.pathnames
        end

        # Performs the Refinery inclusion process which extends the currently loaded Rails
        # applications with Refinery's controllers and helpers. The process is wrapped by
        # a before_inclusion and after_inclusion step that calls procs registered by the
        # Refinery::Engine#before_inclusion and Refinery::Engine#after_inclusion class methods
        def refinery_inclusion!
          before_inclusion_procs.each(&:call)

          Refinery.include_once(::ApplicationController, Refinery::ApplicationController)
          ::ApplicationController.send :helper, Refinery::Core::Engine.helpers

          after_inclusion_procs.each(&:call)
        end
      end

      config.autoload_paths += %W( #{config.root}/lib )

      # Include the refinery controllers and helpers dynamically
      config.to_prepare &method(:refinery_inclusion!).to_proc

      after_inclusion &method(:register_decorators!).to_proc

      # Wrap errors in spans
      config.to_prepare do
        ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
          "<span class=\"fieldWithErrors\">#{html_tag}</span>".html_safe
        end
      end

      initializer "refinery.will_paginate" do
        WillPaginate.per_page = 20
      end

      initializer "register refinery_core plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_core'
          plugin.class_name = 'RefineryEngine'
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /refinery\/(refinery_)?core$/
        end
      end

      initializer "register refinery_dialogs plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_dialogs'
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /refinery\/(refinery_)?dialogs/
        end
      end

      initializer "refinery.routes", :after => :set_routes_reloader_hook do |app|
        Refinery::Core::Engine.routes.append do
          get "#{Refinery::Core.backend_route}/*path" => 'admin#error_404'
        end
      end

      initializer "refinery.autoload_paths" do |app|
        app.config.autoload_paths += [
          Rails.root.join('app', 'presenters'),
          Rails.root.join('vendor', '**', '**', 'app', 'presenters'),
          Refinery.roots.map{|r| r.join('**', 'app', 'presenters')}
        ].flatten
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
          "admin.js"
        ]
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
        Refinery.register_extension(Refinery::Core)
      end
    end
  end
end
