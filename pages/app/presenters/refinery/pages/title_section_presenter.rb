module Refinery
  module Pages
    # A type of SectionPresenter which knows how to render a section which displays
    # a title. These are much like normal sections except they are wrapped in
    # a h1 tag rather than a div.
    class TitleSectionPresenter < SectionPresenter
    private

      def wrap_content_in_tag(content)
        content_tag(:h1, content, :id => id)
      end
    end
  end
end
