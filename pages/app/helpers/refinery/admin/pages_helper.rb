module Refinery
  module Admin
    module PagesHelper
      def parent_id_nested_set_options(current_page)
        pages = []
        nested_set_options(::Refinery::Page, current_page) {|page| pages << page}
        # page.title needs the :translations association, doing something like
        # nested_set_options(::Refinery::Page.includes(:translations), page) doesn't work, yet.
        # See https://github.com/collectiveidea/awesome_nested_set/pull/123
        ActiveRecord::Associations::Preloader.new(pages, :translations).run
        pages.map {|page| ["#{'-' * page.level} #{page.title}", page.id]}
      end
      def selected_template(template_type, current_page)
      	if current_page.send(template_type).nil? then
      		if current_page.parent_id? then
      			# Use Parent Template by default.
      			current_page.parent.send(template_type)
      		else
      			# Use Default Template (First in whitelist)
      			Refinery::Pages.send("#{template_type}_whitelist").first
      		end
      	else
      		# Use Selected Template in Page
      		current_page.send(template_type)
      	end
      end
    end
  end
end
