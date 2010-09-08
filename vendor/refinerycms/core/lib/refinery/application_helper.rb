# Methods added to this helper will be available to all templates in the application.
Dir[File.expand_path('../helpers/*.rb', __FILE__).to_s].each {|helper| require helper}

module Refinery
  module ApplicationHelper
    include Refinery::Helpers::HtmlTruncationHelper
    include Refinery::Helpers::ImageHelper
    include Refinery::Helpers::MenuHelper
    include Refinery::Helpers::MetaHelper
    include Refinery::Helpers::ScriptHelper
    include Refinery::Helpers::SiteBarHelper
    include Refinery::Helpers::TagHelper
    include Refinery::Helpers::TranslationHelper
  end
end
