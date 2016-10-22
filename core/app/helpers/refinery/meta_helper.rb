module Refinery
  module MetaHelper

    # This is used to display the title of the current object (normally a page) in the browser's titlebar.
    #
    def browser_title(yield_title = nil)
      [
        yield_title,
        @meta.browser_title.presence || @meta.path,
        Refinery::Core.site_name
      ].reject(&:blank?).join(" - ")
    end

    # you can override the object used for the title by supplying options[:object]
    def page_title(options = {})
      object = options.fetch(:object, @meta)
      options.delete(:object)
      options = Refinery::Pages.page_title.merge(options)

      title = []
      objects = (options[:chain_page_title] and object.respond_to?(:ancestors)) ? [object.ancestors, object] : [object]

      objects.flatten.compact.each do |obj|
        obj_title = obj.title if obj.title

        # Only link when the object responds to a url method.
        if options[:link] && obj.respond_to?(:url)
          title << link_to(obj_title, obj.url)
        else
          title << obj_title
        end
      end

      final_title = title.pop
      if (options[:page_title][:wrap_if_not_chained] and title.empty?) and options[:page_title][:tag].present?
        css = " class='#{options[:page_title][:class]}'" if options[:page_title][:class].present?
        final_title = "<#{options[:page_title][:tag]}#{css}>#{final_title}</#{options[:page_title][:tag]}>"
      end

      if title.empty?
        final_title.to_s.html_safe
      else
        tag = "<#{options[:ancestors][:tag]} class='#{options[:ancestors][:class]}'>"
        tag << title.join(options[:ancestors][:separator])
        tag << options[:ancestors][:separator]
        tag << "</#{options[:ancestors][:tag]}>#{final_title}"
        tag.html_safe
      end
    end

    def canonical_id(page)
      "#{page.canonical_slug}-page" if page
    end

    def view_template_class(page)
      "template-#{page.view_template}" if page
    end

  end
end
