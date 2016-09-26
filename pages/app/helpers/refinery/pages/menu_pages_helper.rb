module Refinery
  module Pages
    module MenuPagesHelper
      def main_menu(max_depth = 0)
        build_menu(Refinery::Page.fast_menu, nil, 'menu', 'navigation', max_depth)
      end

      def cache_key_for_main_menu(page)
        records = Refinery::Page.fast_menu
        count = records.count
        max_updated_at = (records.map(&:updated_at).max || Date.today).to_s(:number)
        common_menu_cache_keys(page, 'main_menu', max_updated_at, count)
      end

      private

      def common_menu_cache_keys(page, position, max_updated_at, count)
        "#{::I18n.locale}/refinery/#{position}/#{page.id}-#{max_updated_at}-#{count}"
      end

      def build_menu(pages, css, id, role, max_depth = 0)
        menu_items = Refinery::Menu.new pages
        presenter = Refinery::Pages::MenuPresenter.new(menu_items, self)
        presenter.dom_id = id
        presenter.css = css
        presenter.menu_tag = :nav
        presenter.menu_role = role
        presenter.max_depth = max_depth
        presenter
      end
    end
  end
end