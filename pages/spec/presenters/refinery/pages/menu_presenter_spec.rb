require "spec_helper"

module Refinery
  module Pages
    describe MenuPresenter do

      let(:menu_presenter) do
        menu_items = []
        menu_items.stub(:roots)

        MenuPresenter.new(menu_items, view)
      end

      describe "config" do
        it "has default values" do
          expect(menu_presenter.roots).to eq(nil)
          expect(menu_presenter.dom_id).to eq("menu")
          expect(menu_presenter.css).to eq("menu clearfix")
          expect(menu_presenter.menu_tag).to eq(:nav)
          expect(menu_presenter.list_tag).to eq(:ul)
          expect(menu_presenter.list_item_tag).to eq(:li)
          expect(menu_presenter.selected_css).to eq(:selected)
          expect(menu_presenter.first_css).to eq(:first)
          expect(menu_presenter.last_css).to eq(:last)
        end
      end

      describe "#roots" do
        context "when #roots is configured" do
          it "returns config.roots" do
            menu_presenter.config.stub(:roots).and_return(["one", "two", "three"])
            expect(menu_presenter.roots).to eq(["one", "two", "three"])
          end
        end

        context "when #roots isn't configured" do
          it "returns roots from passed in collection" do
            menu_items = double()
            menu_items.stub(:roots).and_return(["three", "two", "one"])

            menu_presenter = MenuPresenter.new(menu_items, view)
            expect(menu_presenter.roots).to eq(["three", "two", "one"])
          end
        end
      end

      describe "#to_html" do
        it "returns menu items wrapped in html" do
          menu_items = Refinery::Menu.new(FactoryGirl.create(:page, :title => "Refinery CMS"))

          menu_presenter = MenuPresenter.new(menu_items, view)
          expect(menu_presenter.to_html).to eq(%Q{<nav class="menu clearfix" id="menu"><ul><li class="first last"><a href="/refinery-cms">Refinery CMS</a></li></ul></nav>})
        end
      end

    end
  end
end
