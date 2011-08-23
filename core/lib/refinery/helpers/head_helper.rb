module Refinery
  module Helpers
    module HeadHelper

      def stylesheets_for_head(stylesheets, theme = false)
        # if theme is set, use themed stylesheet links.
        stylesheets.map! {|ss| ss =~ /^refinery\// ? ss : "/theme/stylesheets/#{ss}" } if theme

        stylesheets
      end

    end
  end
end
