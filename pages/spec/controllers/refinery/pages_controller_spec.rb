require "spec_helper"

module Refinery
  describe PagesController, :type => :controller do
    before do
      FactoryBot.create(:page, link_url:  "/")
      FactoryBot.create(:page, title:  "testing")
      FactoryBot.create(:page, link_url: "/items")
    end

    describe "#home" do
      context "when page path set to default ('/') " do
        it "renders home template" do
          get :home
          expect(response).to render_template("home")
        end
      end

      context "when home_page_path set to another path" do
        it "redirects to the specified path" do
          allow(Refinery::Pages).to receive(:home_page_path).and_return('/items')
          get :home
          expect(response).to redirect_to('/items')
        end
      end
    end

    describe "#show" do
      it "renders show template" do
        get :show, params: {path: "testing"}
        expect(response).to render_template("show")
      end
    end
  end
end
