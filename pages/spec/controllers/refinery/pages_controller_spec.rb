require "spec_helper"

module Refinery
  describe PagesController do
    describe "#home" do
      it "renders home template" do
        create(:page, :link_url => "/")

        get :home
        expect(response).to render_template("home")
      end
    end

    describe "#show" do
      it "renders show template" do
        create(:page, :title => 'test')

        get :show, :path => "test"
        expect(response).to render_template("show")
      end
    end

    context "multisite page selection" do
      let(:pages) { create_list(:page, 2, :site_specific, :link_url => "/") }

      describe "#home" do
        it "populates site specific @page variable" do
          request.host = pages.last.site.hostname

          get :home
          expect(assigns(:page)).to eq pages.last
        end
      end

      describe "#show" do
        it "populates site specific @page variable" do
          request.host = pages.last.site.hostname

          get :show, :path => pages.last.slug
          expect(assigns(:page)).to eq pages.last
        end
      end
    end
  end
end
