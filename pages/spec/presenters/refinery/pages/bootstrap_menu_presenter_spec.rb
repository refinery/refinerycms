require "spec_helper"

module Refinery
  module Pages
    describe BootstrapMenuPresenter do
      let(:bootstrap_menu_presenter) do
        menu_items = []
        menu_items.stub(:roots)
        BootstrapMenuPresenter.new(menu_items, view)
      end

      describe "config" do
        expect(bootstrap_menu_presenter.css).to eq('col-xs-12 nav navbar-nav')
        expect(bootstrap_menu_presenter.menu_tag).to eq(:div)
        expect(bootstrap_menu_presenter.list_tag_css).to eq('nav')
        expect(bootstrap_menu_presenter.selected_css).to eq('active')
        expect(bootstrap_menu_presenter.max_depth).to eq(0)
      end
    end
  end
end
