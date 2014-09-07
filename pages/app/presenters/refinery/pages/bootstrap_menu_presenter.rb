#!/usr/bin/env ruby
##############################################################################
## Author: Robert Miesen
## Date Created: 09/06/2014
## Time-stamp:  <09/06/2014 21:49:24 rmiesen>
##############################################################################

require 'active_support/core_ext/string'
require 'active_support/configurable'
require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'
require_relative 'menu_presenter.rb'


module Refinery
  module Pages
    class BootstrapMenuPresenter < MenuPresenter
      self.css = 'col-xs-12 nav navbar-nav'
      self.menu_tag = :div
      self.list_tag_css = 'nav'
      self.selected_css = 'active'
      self.max_depth = 0
      
    end
  end
end
