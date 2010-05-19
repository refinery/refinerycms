# Methods added to this helper will be available to all templates in the application.
module Refinery::ApplicationHelper

  include Refinery::HtmlTruncationHelper rescue puts "#{__FILE__}:#{__LINE__} Could not load hpricot"

  # This is used to display the title of the current object (normally a page) in the browser's titlebar.
  #
  def browser_title(yield_title=nil)
    [
      yield_title.present? ? yield_title : nil,
      @meta.browser_title.present? ? @meta.browser_title : @meta.path,
      RefinerySetting.find_or_set(:site_name, "Company Name")
    ].compact.join(" - ")
  end

  # replace all system images with a thumbnail version of them (handy for all images inside a page part)
  # for example, <%= content_fu(@page[:body], :preview) %> converts all /system/images to their 'preview' thumbnail
  def content_fu(content, thumbnail)
    content.scan(/\/system\/images([^\"\ ]*)/).flatten.each do |match|
      parts = match.split(".")
      extension = parts.pop
      content.gsub!(match, "#{parts.join(".")}_#{thumbnail}.#{extension}")
    end

    return content
  end

  # Determines whether any page underneath the supplied page is the current page according to rails.
  # Just calls selected_page? for each descendant of the supplied page.
  def descendant_page_selected?(page)
    page.descendants.any? {|descendant| selected_page?(descendant) }
  end

  # image_fu is a helper for inserting an image that has been uploaded into a template.
  # Say for example that we had a @model.image (@model having a belongs_to :image relationship)
  # and we wanted to display the 'preview' thumbnail then we can use image_fu like this:
  # <%= image_fu @model.image, :preview %> or with no thumbnail: <%= image_fu @model.image %>
  def image_fu(image, thumbnail = nil , options={})
    if image.present?
      # if a thumbnail name was specified then find the thumbnail belonging to this image with that name, if existant.
      image_thumbnail = image.thumbnails.detect {|t| t.thumbnail == thumbnail.to_s} unless thumbnail.nil?

      # default back to using the image specified as the "thumbnail" if we didn't find one.
      image_thumbnail = image unless image_thumbnail.present?

      # call rails' image tag function with default alt, width and height options.
      # if any other options were supplied these are merged in and can replace the defaults.
      image_tag(image_thumbnail.public_filename, {:alt => image.respond_to?(:title) ? image.title : image.filename,
                                                  :width => image_thumbnail.width,
                                                  :height => image_thumbnail.height
                                                 }.merge!(options))
    end
  end

  # This function helps when including both the jquery and jqueryui libraries.
  # If you use this function then whenever we update or relocate the version of jquery or jquery ui in use
  # we will update the reference here and your existing application starts to use it.
  # Use <%= jquery_include_tags %> to include it in your <head> section.
  def jquery_include_tags(use_caching = RefinerySetting.find_or_set(:use_resource_caching, true),
                          use_google = RefinerySetting.find_or_set(:use_google_ajax_libraries, false))
    # render the tags normally unless
    unless use_google and !local_request?
      javascript_include_tag 'jquery', 'jquery-ui', :cache => (use_caching ? "cache/libraries" : nil)
    else
      "#{javascript_include_tag("http://www.google.com/jsapi").gsub(".js", "")}
      <script type='text/javascript'>
        google.load('jquery', '1.4');
        google.load('jqueryui', '1.8');
      </script>"
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
      css = options[:page_title][:class].present? ? " class='#{options[:page_title][:class]}'" : nil
      final_title = "<#{options[:page_title][:tag]}#{css}>#{final_title}</#{options[:page_title][:tag]}>"
    end

    if title.empty?
      return final_title
    else
      return "<#{options[:ancestors][:tag]} class='#{options[:ancestors][:class]}'>#{title.join options[:ancestors][:separator]}#{options[:ancestors][:separator]}</#{options[:ancestors][:tag]}>#{final_title}"
    end
  end

  # This is just a quick wrapper to render an image tag that lives inside refinery/icons.
  # They are all 16x16 so this is the default but is able to be overriden with supplied options.
  def refinery_icon_tag(filename, options = {})
    image_tag "refinery/icons/#{filename}", {:width => 16, :height => 16}.merge!(options)
  end

  # Determine whether the supplied page is the currently open page according to Rails.
  def selected_page?(page)
    current_page?(page) or
      (request.path =~ Regexp.new(page.menu_match) if page.menu_match.present?) or
      (request.path == page.link_url) or
      (request.path == page.url)
  end

end
