require File.expand_path('../../refinery', __FILE__)
require 'truncate_html'
require 'will_paginate'
require 'refinery/i18n'

module Refinery
  module Core
    require 'refinery/core/engine'
    require 'refinery/core/configuration'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
