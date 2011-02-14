require 'pathname'

require File.expand_path('../refinerycms', __FILE__)

# Construct the ability to call Refinery.root
# Must come after requiring 'refinerycms'
module Refinery
  class << self
    attr_accessor :root
    def root
      @root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end
