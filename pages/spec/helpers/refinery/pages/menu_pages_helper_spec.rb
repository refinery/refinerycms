require 'spec_helper'

module Refinery
  module Pages
    describe MenuPagesHelper, type: :helper do
      describe "#main_menu" do
        it "build the main menu" do
          page = FactoryGirl.create(:page)
          expect(helper.main_menu(1).to_html).to xml_eq(
            %Q{<nav id="menu" role="navigation"><ul class="nav"><li class="first last"><a href="#{page.slug}">#{page.title}</a></li></ul></nav>}
          )
        end
      end

      describe "#cache_key_for_main_menu" do
        it "create the cache key for the main menu" do
          page = FactoryGirl.create(:page)
          expect(helper.cache_key_for_main_menu(page)).to eq("en/refinery/main_menu/#{page.id}-#{page.updated_at.to_s(:number)}-1")
        end
      end
    end
  end
end
