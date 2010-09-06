# Methods added to this helper will be available to all templates in the application.
module Refinery
  module ApplicationHelper
    include Refinery::HtmlTruncationHelper
    include Refinery::ImageHelper
    include Refinery::MenuHelper
    include Refinery::MetaHelper
    include Refinery::ScriptHelper
    include Refinery::SiteBarHelper
    include Refinery::TagHelper
    include Refinery::TranslationHelper
  end
end
