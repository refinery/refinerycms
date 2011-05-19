module Refinery
  module Helpers
    module PageHelper

      def page_sections(page, local_assigns={})
        if local_assigns[:sections].blank?
          # always have a title
          sections = [{:yield => :body_content_title,
              :fallback => page_title,
              :title => true}]
          # append sections from this page.
          page.parts.inject(sections) do |s, part|
            # we have some default yields,
            # body_content_left and body_content_right these
            # map to 'body' and 'side_body' fields in default Refinery.
            section = {:fallback => part.body}
            title_symbol = part.title.to_s.gsub(/\ /, '').underscore.to_sym
            section[:yield] = case (title_symbol)
                              when :body then :body_content_left
                              when :side_body then :body_content_right
                              else title_symbol
                              end

            # add section to the list unless
            # we were specifically requested not to.
            if !(local_assigns[:hide_sections]||=[]).include?(section[:yield])
              s << section
            end
          end unless page.nil? or page.parts.blank?

          # Ensure that even without @page.parts we
          # still have body_content_left and body_content_right.
          all_yields = sections.collect{|s| s[:yield]}
            sections << {:yield => :body_content_left} unless \
          all_yields.include?(:body_content_left)
            sections << {:yield => :body_content_right} unless \
          all_yields.include?(:body_content_right)
        end
        sections
      end

      def page_html(section=[], local_assigns={})
        if section[:html].blank? \
          and !local_assigns[:show_empty_sections] \
          and !local_assigns[:remove_automatic_sections] \
          and section.keys.include?(:fallback) \
          and section[:fallback].present?
            section[:html] = raw(section[:fallback])
        end

        raw_html = section[:html]
        dom_id = section[:id] || section[:yield]

        if section[:title]
          content_tag(:h1, raw_html.html_safe, :id => dom_id)
        else
          content_tag :div, :id => dom_id, do
            content_tag(:section, raw_html.html_safe, :class => 'inner')
          end
        end
      end

      def page_body_content(&block)
        if block_given?
          content = capture(&block)
          content_tag :section, content, :id => 'body_content'
        end
      end

    end
  end
end
