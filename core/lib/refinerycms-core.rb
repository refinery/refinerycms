require 'acts_as_indexed'
require 'truncate_html'
require 'will_paginate'

module Refinery
  autoload :Activity, File.expand_path('../refinery/activity', __FILE__)
  autoload :Application, File.expand_path('../refinery/application', __FILE__)
  autoload :ApplicationController, File.expand_path('../refinery/application_controller', __FILE__)
  autoload :ApplicationHelper, File.expand_path('../refinery/application_helper', __FILE__)
  autoload :Configuration, File.expand_path('../refinery/configuration', __FILE__)
  autoload :Engine, File.expand_path('../refinery/engine', __FILE__)
  autoload :Menu, File.expand_path('../refinery/menu', __FILE__)
  autoload :MenuItem, File.expand_path('../refinery/menu_item', __FILE__)
  autoload :Plugin,  File.expand_path('../refinery/plugin', __FILE__)
  autoload :Plugins, File.expand_path('../refinery/plugins', __FILE__)
end

# These have to be specified after the autoload to correct load issues on some systems.
# As per commit 12af0e3e83a147a87c97bf7b29f343254c5fcb3c
require 'refinerycms-base'
require 'refinerycms-settings'
require 'rails/generators'
require 'rails/generators/migration'
require File.expand_path('../generators/cms_generator', __FILE__)

module Refinery

  class << self
    def config
      @@config ||= ::Refinery::Configuration.new
    end
  end

  module Core
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
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    ::Rails::Engine.send :include, ::Refinery::Engine
  end
end

require 'refinery/core/engine'
::Refinery.engines << 'core'
