require 'active_support/concern'

module Refinery

  # == Refinery Helpers ==
  #
  # The entire collection of Refinery's view helpers which can be used to extend your own
  # application's view helpers.
  #
  # All of Refinery's helpers will be included by including this module into a view helper,
  # if you wish to include a portion of Refinery's view helpers then you should include them
  # on a one by one basis.
  module Helpers
    extend ActiveSupport::Concern

    require 'refinery/helpers/form_helper'
    require 'refinery/helpers/html_truncation_helper'
    require 'refinery/helpers/image_helper'
    require 'refinery/helpers/menu_helper'
    require 'refinery/helpers/meta_helper'
    require 'refinery/helpers/pagination_helper'
    require 'refinery/helpers/script_helper'
    require 'refinery/helpers/site_bar_helper'
    require 'refinery/helpers/tag_helper'
    require 'refinery/helpers/translation_helper'

    included do
      send :include, Refinery::Helpers::HtmlTruncationHelper
      send :include, Refinery::Helpers::ImageHelper
      send :include, Refinery::Helpers::MenuHelper
      send :include, Refinery::Helpers::MetaHelper
      send :include, Refinery::Helpers::PaginationHelper
      send :include, Refinery::Helpers::ScriptHelper
      send :include, Refinery::Helpers::SiteBarHelper
      send :include, Refinery::Helpers::TagHelper
      send :include, Refinery::Helpers::TranslationHelper
    end
  end
end
