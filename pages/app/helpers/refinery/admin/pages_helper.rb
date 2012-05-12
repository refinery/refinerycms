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
    end
  end
end
