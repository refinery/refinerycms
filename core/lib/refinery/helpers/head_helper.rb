module Refinery
  module Helpers
    module HeadHelper

      def stylesheets_for_head(stylesheets, theme = false)
        # you can disable the use of the built-in refinery stylesheets by disabling the setting.
        stylesheets.map! {|ss| ["refinery/#{ss}", ss] }.flatten! if ::Refinery::Setting.find_or_set(:frontend_refinery_stylesheets_enabled, true)

        # if theme is set, use themed stylesheet links.
        stylesheets.map! {|ss| ss =~ /^refinery\// ? ss : "/theme/stylesheets/#{ss}" } if theme

        stylesheets
      end

    end
  end
end
