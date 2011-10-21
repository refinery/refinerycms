require 'rails/all'
require 'rbconfig'
require 'acts_as_indexed'
require 'truncate_html'
require 'will_paginate'

module Refinery
  WINDOWS = !!(RbConfig::CONFIG['host_os'] =~ %r!(msdos|mswin|djgpp|mingw)!) unless defined? WINDOWS

  require 'refinery/errors'

  autoload :Activity, 'refinery/activity'
  autoload :Application, 'refinery/application'
  autoload :ApplicationController, 'refinery/application_controller'
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

  require 'refinery/ext/action_view/helpers/form_builder'
  require 'refinery/ext/action_view/helpers/form_helper'
  require 'refinery/ext/action_view/helpers/form_tag_helper'

  class << self
    attr_accessor :gems

    @@engines = []

    # Convenience method for Refinery::Core#rescue_not_found
    def rescue_not_found
      Core.rescue_not_found
    end

    # Convenience method for Refinery::Core#s3_backend
    def s3_backend
      Core.s3_backend
    end

    # Convenience method for Refinery::Core#base_cache_key
    def base_cache_key
      Core.base_cache_key
    end

    # Returns an array of modules representing currently registered Refinery Engines
    #
    # Example:
    #   Refinery.engines  =>  [Refinery::Core, Refinery::Pages]
    def engines
      @@engines
    end

    # Register an engine with Refinery
    #
    # Example:
    #   Refinery.register_engine(Refinery::Core)
    def register_engine(const)
      return if engine_registered?(const)

      validate_engine!(const)

      @@engines << const
    end

    # Unregister an engine from Refinery
    #
    # Example:
    #   Refinery.unregister_engine(Refinery::Core)
    def unregister_engine(const)
      @@engines.delete(const)
    end

    # Returns true if an engine is currently registered with Refinery
    #
    # Example:
    #   Refinery.engine_registered?(Refinery::Core)
    def engine_registered?(const)
      @@engines.include?(const)
    end

    # Constructs a deprecation warning message and warns with Kernel#warn
    #
    # Example:
    #   Refinery.deprecate('foo') => "The use of 'foo' is deprecated"
    #
    # An options parameter can be specified to construct a more detailed deprecation message
    #
    # Options:
    #   when - version that this deprecated feature will be removed
    #   replacement - a replacement for what is being deprecated
    #   caller - who called the deprecated feature
    #
    # Example:
    #   Refinery.deprecate('foo', :when => 'tomorrow', :replacement => 'bar') =>
    #       "The use of 'foo' is deprecated and will be removed at version 2.0. Please use 'bar' instead."
    def deprecate(what, options = {})
      # Build a warning.
      warning = "\n-- DEPRECATION WARNING --\n"
      warning << "The use of '#{what}' is deprecated"
      warning << " and will be removed at version #{options[:when]}" if options[:when]
      warning << "."
      warning << "\nPlease use #{options[:replacement]} instead." if options[:replacement]

      # See if we can trace where this happened
      if options[:caller]
        whos_calling = options[:caller].detect{|c| c =~ %r{#{Rails.root.to_s}}}.inspect.to_s.split(':in').first
        warning << "\nCalled from: #{whos_calling}\n"
      end

      # Give stern talking to.
      warn warning
    end

    def i18n_enabled?
      !!(defined?(::Refinery::I18n) && ::Refinery::I18n.enabled?)
    end

    # Returns a Pathname to the root of the RefineryCMS project
    def root
      @root ||= Pathname.new(File.expand_path('../../../../', __FILE__))
    end

    # Returns an array of Pathnames pointing to the root directory of each engine that
    # has been registered with Refinery.
    #
    # Example:
    #   Refinery.roots => [#<Pathname:/Users/Reset/Code/refinerycms/core>, #<Pathname:/Users/Reset/Code/refinerycms/pages>]
    #
    # An optional engine_name parameter can be specified to return just the Pathname for
    # the specified engine. This can be represented in Constant, Symbol, or String form.
    #
    # Example:
    #   Refinery.roots(Refinery::Core)    =>  #<Pathname:/Users/Reset/Code/refinerycms/core>
    #   Refinery.roots(:'refinery/core')  =>  #<Pathname:/Users/Reset/Code/refinerycms/core>
    #   Refinery.roots("refinery/core")   =>  #<Pathname:/Users/Reset/Code/refinerycms/core>
    def roots(engine_name = nil)
      if engine_name.nil?
        return @roots ||= self.engines.map { |engine| engine.root }
      end

      engine_name.to_s.camelize.constantize.root
    end

    def version
      Refinery::Version.to_s
    end

    private
      def validate_engine!(const)
        unless const.respond_to?(:root) && const.root.is_a?(Pathname)
          raise InvalidEngineError, "Engine must define a root accessor that returns a pathname to it it's root"
        end
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

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
