# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def add_meta_tags
		content_for :head, "<meta name=\"keywords\" content=\"#{@page.meta_keywords}\" />" unless @page.meta_keywords.blank?
		content_for :head, "<meta name=\"description\" content=\"#{@page.meta_description}\" />" unless @page.meta_description.blank?
  end
  
  def add_page_title
		content_for :title, 
		if @page.browser_title.blank?
    	@page.path
    else
    	@page.browser_title
    end
  end
  
  def setup
    add_meta_tags
    add_page_title
  end
  
  def page_title(options = {})
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
    pages = options[:chain_page_title] ? [@page.ancestors, @page].flatten : [@page]

		pages.flatten.each do |page|
			title << case page.custom_title_type
	      when "none"
	        page.title
	      when "text"
	        page.custom_title
	      when "image"
	        image_fu page.custom_title_image, nil, {:alt => page.title} rescue page.title
	    end
		end
		
		final_title = title.pop
		if (options[:page_title][:wrap_if_not_chained] and title.empty?) and !options[:page_title][:tag].blank?
			final_title = "<#{options[:page_title][:tag]}#{" class='#{options[:page_title][:class]}'" unless options[:page_title][:class].blank?}>#{final_title}</#{options[:page_title][:tag]}>"
		end
		if (title.empty?)
			final_title
		else
			"<#{options[:ancestors][:tag]} class='#{options[:ancestors][:class]}'>#{title.join options[:ancestors][:separator]}#{options[:ancestors][:separator]}</#{options[:ancestors][:tag]}>#{final_title}"
		end
  end
  
  def descendant_page_selected?(page)
		not page.descendants.reject {|descendant| not selected_page?(descendant) }.empty?
  end
  
  def selected_page?(page)
    selected = current_page?(page) or (request.path =~ Regexp.new(page.menu_match) unless page.menu_match.blank?) or (request.path == page.link_url)
  end	

	def image_fu(image, thumbnail = nil , options={})
		begin
			image_thumbnail = thumbnail.nil? ? image : image.thumbnails.collect {|t| t if t.thumbnail == thumbnail.to_s}.compact.first 
			image_tag image_thumbnail.public_filename, {:alt => image.title, :width => image_thumbnail.width, :height => image_thumbnail.height}.merge!(options)
		rescue
			image_tag image.public_filename(thumbnail), {:alt => image.title}.merge!(options)
		end
	end
	
	def refinery_icon_tag(filename, options = {})
		image_tag "refinery/icons/#{filename}", {:width => 16, :height => 16}.merge!(options)
	end
	
end