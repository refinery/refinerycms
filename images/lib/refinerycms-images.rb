require 'dragonfly'
require 'rack/cache'
require 'refinerycms-core'
require File.expand_path('../generators/images_generator', __FILE__)

module Refinery
  module Images    
    autoload :Dragonfly, 'refinery/images/dragonfly'
    autoload :Validators, 'refinery/images/validators'
    
    class Options
      include Rails::Railtie::Configurable
      
      cattr_accessor :max_image_size
      self.max_image_size = 5242880
      
      cattr_accessor :pages_per_dialog
      self.pages_per_dialog = 18
      
      cattr_accessor :pages_per_dialog_that_have_size_options
      self.pages_per_dialog_that_have_size_options = 12
      
      cattr_accessor :pages_per_admin_index
      self.pages_per_admin_index = 20
    end

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end
  end
end

require 'refinery/images/engine'
::Refinery.engines << 'dashboard'
