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
    attr_accessor :gems

    # Convenience method for Refinery::Core#rescue_not_found
    #
    def rescue_not_found
      Core.rescue_not_found
    end

    # Convenience method for Refinery::Core#s3_backend
    #
    def s3_backend
      Core.s3_backend
    end

    # Convenience method for Refinery::Core#base_cache_key
    #
    def base_cache_key
      Core.base_cache_key
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

    def version
      ::Refinery::Version.to_s
    end

    def config
      @@config ||= ::Refinery::Configuration.new
    end
  end

  module Core
    require 'refinery/core/engine' if defined?(Rails)

    DEFAULT_RESCUE_NOT_FOUND = false
    DEFAULT_S3_BACKEND = false
    DEFAULT_BASE_CACHE_KEY = :refinery

    mattr_accessor :rescue_not_found
    self.rescue_not_found = DEFAULT_RESCUE_NOT_FOUND

    mattr_accessor :s3_backend
    self.s3_backend = DEFAULT_S3_BACKEND

    mattr_accessor :base_cache_key
    self.base_cache_key = DEFAULT_BASE_CACHE_KEY

    class << self
      # Configure the options of Refinery::Pages.
      #
      #   Refinery::Core.configure do |config|
      #     config.rescue_not_found = false
      #   end
      #
      def configure(&block)
        yield Refinery::Core
      end

      # Reset Refinery::Core options to their default values
      #
      def reset!
        self.rescue_not_found = DEFAULT_RESCUE_NOT_FOUND
        self.s3_backend = DEFAULT_S3_BACKEND
        self.base_cache_key = DEFAULT_BASE_CACHE_KEY
      end

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

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
