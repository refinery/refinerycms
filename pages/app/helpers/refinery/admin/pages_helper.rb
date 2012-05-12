module Refinery
  module Admin
    module PagesHelper
      def parent_id_nested_set_options(current_page)
        all_pages = []
        options = nested_set_options(::Refinery::Page, current_page) do |page|
          all_pages << page
          page
        end
        # page.title needs the :translations association, doing something like
        # nested_set_options(::Refinery::Page.includes(:translations), page) doesn't work
        ActiveRecord::Associations::Preloader.new(all_pages, :translations).run
        options.map! {|page, id| ["#{'-' * page.level} #{page.title}", id]}
        options
      end
    end
  end
end
