require "spec_helper"

module Refinery
  module Pages
    describe MenuPresenter do
      let!(:original_mounted_path) { Core.mounted_path }
      let(:mounted_path) { "/" }

      before do
        allow(Core).to receive(:mounted_path).and_return(mounted_path)
        Rails.application.reload_routes!
      end

      after do
        allow(Core).to receive(:mounted_path).and_return(original_mounted_path)
        Rails.application.reload_routes!
      end

      let(:menu_presenter) do
        menu_items = []
        allow(menu_items).to receive(:roots)

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
          expect(menu_presenter.active_css).to eq(:active)
          expect(menu_presenter.selected_css).to eq(:selected)
          expect(menu_presenter.first_css).to eq(:first)
          expect(menu_presenter.last_css).to eq(:last)
          expect(menu_presenter.list_tag_css).to eq("nav")
        end
      end

      describe "#roots" do
        context "when #roots is configured" do
          it "returns config.roots" do
            allow(menu_presenter.config).to receive(:roots).and_return(["one", "two", "three"])
            expect(menu_presenter.roots).to eq(["one", "two", "three"])
          end
        end

        context "when #roots isn't configured" do
          it "returns roots from passed in collection" do
            menu_items = double()
            allow(menu_items).to receive(:roots).and_return(["three", "two", "one"])

            menu_presenter = MenuPresenter.new(menu_items, view)
            expect(menu_presenter.roots).to eq(["three", "two", "one"])
          end
        end
      end

      describe "#to_html" do
        let(:menu_items) {
          Refinery::Menu.new(FactoryGirl.create(:page, :title => "Refinery CMS"))
        }
        let(:menu_presenter) { MenuPresenter.new(menu_items, view) }
        
        context "wrapped in html" do
          it "returns menu items" do
            expect(menu_presenter.to_html).to xml_eq(
              %Q{<nav class="menu clearfix" id="menu"><ul class="nav"><li class="first last"><a href="/refinery-cms">Refinery CMS</a></li></ul></nav>}
            )
          end

          context "with role set to navigation" do
            let(:menu_presenter_with_role) { 
              menu_presenter.menu_role = 'navigation'
              menu_presenter
            }

            it "returns menu items wrapped in html with role set to navigation" do
              expect(menu_presenter_with_role.to_html).to xml_eq(
                %Q{<nav class="menu clearfix" id="menu" role="navigation"><ul class="nav"><li class="first last"><a href="/refinery-cms">Refinery CMS</a></li></ul></nav>}
              )
            end
          end
        end

        context "takes mount point into account" do
          let(:mounted_path) { "/subfolder"}

          it "for normal pages" do
            expect(menu_presenter.to_html).to xml_eq(
              %Q{<nav class="menu clearfix" id="menu"><ul class="nav"><li class="first last"><a href="#{mounted_path}/refinery-cms">Refinery CMS</a></li></ul></nav>}
            )
          end

          context "when page has a link_url" do
            let(:menu_items) {
              Menu.new(FactoryGirl.create(:page, title: "Home", link_url: "/"))
            }
            it "the menu item URL includes the mounted path" do
              expect(menu_presenter.to_html).to xml_eq(
                %Q{<nav class="menu clearfix" id="menu"><ul class="nav"><li class="first last"><a href="#{mounted_path}">Home</a></li></ul></nav>}
              )
            end
          end
        end
      end

    end
  end
end
