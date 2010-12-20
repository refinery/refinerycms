module Refinery
  module Helpers
    module MetaHelper

      # This is used to display the title of the current object (normally a page) in the browser's titlebar.
      #
      def browser_title(yield_title=nil)
        [
          (yield_title if yield_title.present?),
          @meta.browser_title.present? ? @meta.browser_title : @meta.path,
          RefinerySetting.find_or_set(:site_name, "Company Name")
        ].compact.join(" - ")
      end

      # you can override the object used for the title by supplying options[:object]
      # this object must support custom_title_type if you want custom titles.
      def page_title(options = {})
        object = options.fetch(:object, @meta)
        options.delete(:object)
        options = RefinerySetting.find_or_set(:page_title, {
          :chain_page_title => false,
          :ancestors => {
            :separator => " | ",
            :class => 'ancestors',
            :tag => 'span'
          },
          :page_title => {
            :class => nil,
            :tag => nil,
            :wrap_if_not_chained => false
          }
        }).merge(options)

        title = []
        objects = (options[:chain_page_title] and object.respond_to?(:ancestors)) ? [object.ancestors, object] : [object]

        objects.flatten.compact.each do |obj|
          if obj.respond_to?(:custom_title_type)
            title << case obj.custom_title_type
              when "text"
                obj.custom_title
              when "image"
                image_fu(obj.custom_title_image, nil, {:alt => obj.title}) rescue obj.title
              else
                obj.title
              end
          else
            title << obj.title
          end
        end

        final_title = title.pop
        if (options[:page_title][:wrap_if_not_chained] and title.empty?) and options[:page_title][:tag].present?
          css = " class='#{options[:page_title][:class]}'" if options[:page_title][:class].present?
          final_title = "<#{options[:page_title][:tag]}#{css}>#{final_title}</#{options[:page_title][:tag]}>"
        end

        if title.empty?
          return final_title.to_s.html_safe
        else
          return "<#{options[:ancestors][:tag]} class='#{options[:ancestors][:class]}'>#{title.join options[:ancestors][:separator]}#{options[:ancestors][:separator]}</#{options[:ancestors][:tag]}>#{final_title}".html_safe
        end
      end

    end
  end
end
