require 'refinerycms-core'
require 'awesome_nested_set'
require 'globalize3'
require 'friendly_id'
require 'seo_meta'
require File.expand_path('../generators/pages_generator', __FILE__)

module Refinery
  module Pages
    module Admin
      autoload :InstanceMethods, 'refinery/pages/admin/instance_methods'
    end

    autoload :InstanceMethods, 'refinery/pages/instance_methods'
    autoload :Options, 'refinery/pages/options'

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end

      def use_marketable_urls?
        ::Refinery::Setting.find_or_set(:use_marketable_urls, true, :scoping => 'pages')
      end

      def use_marketable_urls=(value)
        ::Refinery::Setting.set(:use_marketable_urls, :value => value, :scoping => 'pages')
      end

      def factory_paths
        @factory_paths ||= [ File.expand_path("../../spec/factories", __FILE__) ]
      end
    end
  end
end

require 'refinery/pages/engine'
::Refinery.engines << 'pages'
