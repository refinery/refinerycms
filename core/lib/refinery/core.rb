require 'rails/all'
require 'rbconfig'
require 'acts_as_indexed'
require 'truncate_html'
require 'will_paginate'

module Refinery
  WINDOWS = !!(RbConfig::CONFIG['host_os'] =~ %r!(msdos|mswin|djgpp|mingw)!) unless defined? WINDOWS

  autoload :Activity, 'refinery/activity'
  autoload :Application, 'refinery/application'
  autoload :ApplicationController, 'refinery/application_controller'
  autoload :ApplicationHelper, 'refinery/application_helper'
  autoload :Configuration, 'refinery/configuration'
  autoload :Engine, 'refinery/engine'
  autoload :Menu, 'refinery/menu'
  autoload :MenuItem, 'refinery/menu_item'
  autoload :Plugin,  'refinery/plugin'
  autoload :Plugins, 'refinery/plugins'
  autoload :Version, 'refinery/version'

  # These have to be specified after the autoload to correct load issues on some systems.
  # As per commit 12af0e3e83a147a87c97bf7b29f343254c5fcb3c
  require 'refinerycms-settings'
  require 'refinery/generators'

  class << self
    attr_accessor :base_cache_key, :gems, :rescue_not_found, :root, :roots, :s3_backend

    def base_cache_key
      @base_cache_key ||= :refinery
    end

    def deprecate(options = {})
      # Build a warning.
      warning = "\n-- DEPRECATION WARNING --"
      warning << "\nThe use of '#{options[:what]}' is deprecated"
      warning << " and will be removed at version #{options[:when]}." if options[:when]
      warning << "\nPlease use #{options[:replacement]} instead." if options[:replacement]

      # See if we can trace where this happened
      if options[:caller]
        whos_calling = options[:caller].detect{|c| c =~ %r{#{Rails.root.to_s}}}.inspect.to_s.split(':in').first
        warning << "\nCalled from: #{whos_calling}\n"
      end

      # Give stern talking to.
      warn warning
    end

    def engines
      @engines ||= []
    end

    def i18n_enabled?
      !!(defined?(::Refinery::I18n) && ::Refinery::I18n.enabled?)
    end

    def rescue_not_found
      !!@rescue_not_found
    end

    def root
      @root ||= Pathname.new(File.expand_path('../../../../', __FILE__))
    end

    def roots(engine_name = nil)
      if engine_name.nil?
        @roots ||= self.engines.map {|engine| "::Refinery::#{engine.camelize}".constantize.root }.uniq
      else
        unless (engine_name = self.engines.detect{|engine| engine.to_s == engine_name.to_s}).nil?
          "::Refinery::#{engine_name.camelize}".constantize.root
        end
      end
    end

    def s3_backend
      @s3_backend ||= false
    end

    def version
      ::Refinery::Version.to_s
    end

    def config
      @@config ||= ::Refinery::Configuration.new
    end
  end

  module Core
    require 'refinery/core/engine' if defined?(Rails)

    class << self
      def attach_to_application!
        ::Rails::Application.subclasses.each do |subclass|
          begin
            # Fix Rake 0.9.0 issue
            subclass.send :include, ::Rake::DSL if defined?(::Rake::DSL)

            # Include our logic inside your logic
            subclass.send :include, ::Refinery::Application
          rescue
            $stdout.puts "Refinery CMS couldn't attach to #{subclass.name}."
            $stdout.puts "Error was: #{$!.message}"
            $stdout.puts $!.backtrace
          end
        end
      end

      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
