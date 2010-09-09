module Refinery
  module Helpers
    module TagHelper

      # Returns <span class='help' title='Your Input'>(help)</span>
      # Remember to wrap your block with <span class='label_with_help'></span> if you're using a label next to the help tag.
      def refinery_help_tag(title='')
        "<span class='help' title='#{title}'>(#{t('shared.admin.help')})</span>".html_safe
      end

      # This is just a quick wrapper to render an image tag that lives inside refinery/icons.
      # They are all 16x16 so this is the default but is able to be overriden with supplied options.
      def refinery_icon_tag(filename, options = {})
        image_tag "refinery/icons/#{filename}", {:width => 16, :height => 16}.merge(options)
      end

    end
  end
end
