module Refinery
  module Pages
    class TitleSectionPresenter < SectionPresenter

      private

        def wrap_content_in_tag(content)
          content_tag(:h1, content, :id => id)
        end


    end
  end
end