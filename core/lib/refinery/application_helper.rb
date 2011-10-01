# Methods added to this helper will be available to all templates in the application.
Dir[File.expand_path('../helpers/*.rb', __FILE__).to_s].each {|helper| require helper}

module Refinery
  module ApplicationHelper
    def self.included(base)
      base.send :include, ::Refinery::Helpers::HtmlTruncationHelper
      base.send :include, ::Refinery::Helpers::ImageHelper
      base.send :include, ::Refinery::Helpers::MenuHelper
      base.send :include, ::Refinery::Helpers::MetaHelper
      base.send :include, ::Refinery::Helpers::PaginationHelper
      base.send :include, ::Refinery::Helpers::ScriptHelper
      base.send :include, ::Refinery::Helpers::SiteBarHelper
      base.send :include, ::Refinery::Helpers::TagHelper
      base.send :include, ::Refinery::Helpers::TranslationHelper
    end
  end
end
