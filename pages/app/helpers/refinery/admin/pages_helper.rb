module Refinery
  module Admin
    module PagesHelper
      def parent_id_nested_set_options(current_page)
        pages = []
        options = nested_set_options(::Refinery::Page, current_page) do |page|
          pages << page
          page
        end
        # page.title needs the :translations association, doing something like
        # nested_set_options(::Refinery::Page.includes(:translations), page) doesn't work, yet.
        # See https://github.com/collectiveidea/awesome_nested_set/pull/123
        ActiveRecord::Associations::Preloader.new(pages, :translations).run
        options.map {|page, id| ["#{'-' * page.level} #{page.title}", id]}
      end
    end
  end
end
