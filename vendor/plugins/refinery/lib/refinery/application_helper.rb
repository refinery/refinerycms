# Methods added to this helper will be available to all templates in the application.
module Refinery::ApplicationHelper

  include Refinery::HtmlTruncationHelper rescue puts "#{__FILE__}:#{__LINE__} Could not load hpricot"

  def browser_title(yield_title=nil)
    [
      yield_title.present? ? yield_title : nil,
      @meta.browser_title.present? ? @meta.browser_title : @meta.path,
      RefinerySetting.find_or_set(:site_name, "Company Name")
    ].compact.join(" - ")
  end

  # replace all system images with a thumbnail version of them (handy for all images inside a page part)
  def content_fu(content, thumbnail)
    content.scan(/\/system\/images([^\"\ ]*)/).flatten.each do |match|
      parts = match.split(".")
      extension = parts.pop
      content.gsub!(match, "#{parts.join(".")}_#{thumbnail}.#{extension}")
    end

    return content
  end

  def descendant_page_selected?(page)
    page.descendants.any? {|descendant| selected_page?(descendant) }
  end

  def image_fu(image, thumbnail = nil , options={})
    if image.present?
      image_thumbnail = image.thumbnails.detect {|t| t.thumbnail == thumbnail.to_s}
      image_thumbnail = image unless image_thumbnail.present?
      image_tag image_thumbnail.public_filename, {:alt => image.title, :width => image_thumbnail.width, :height => image_thumbnail.height}.merge!(options)
    end
  end

  def jquery_include_tags(use_caching=RefinerySetting.find_or_set(:use_resource_caching, false))
    if !local_request? and RefinerySetting.find_or_set(:use_google_ajax_libraries, true)
      "#{javascript_include_tag("http://www.google.com/jsapi").gsub(".js", "")}
      <script type='text/javascript'>
        google.load('jquery', '1.4');
        //google.load('jqueryui', '1.8');
        // google isn't using jqueryui 1.8 yet although it was before.
      </script>
      #{javascript_include_tag 'jquery-ui-1.8.min.js'}"
    else
      javascript_include_tag 'jquery', 'jquery-ui-1.8.min.js', :cache => (use_caching ? "cache/libraries" : nil)
    end
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

    objects.flatten.each do |obj|
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
      css = options[:page_title][:class].present? ? " class='#{options[:page_title][:class]}'" : nil
      final_title = "<#{options[:page_title][:tag]}#{css}>#{final_title}</#{options[:page_title][:tag]}>"
    end

    if title.empty?
      return final_title
    else
      return "<#{options[:ancestors][:tag]} class='#{options[:ancestors][:class]}'>#{title.join options[:ancestors][:separator]}#{options[:ancestors][:separator]}</#{options[:ancestors][:tag]}>#{final_title}"
    end
  end

  def refinery_icon_tag(filename, options = {})
    image_tag "refinery/icons/#{filename}", {:width => 16, :height => 16}.merge!(options)
  end

  def selected_page?(page)
    current_page?(page) or
      (request.path =~ Regexp.new(page.menu_match) if page.menu_match.present?) or
      (request.path == page.link_url)
  end

  def setup
    logger.warn("*** Refinery::ApplicationHelper::setup has now been deprecated from the Refinery API. ***")
  end

end
