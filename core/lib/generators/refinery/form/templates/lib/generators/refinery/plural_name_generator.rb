module Refinery
  class <%= class_name.pluralize %> < Rails::Generators::Base

    source_root File.expand_path('../../', __FILE__)
    engine_name "<%= plural_name %>"

  end
end