require "spec_helper"

module Refinery
  describe PagesController, :type => :controller do
    before do
      FactoryGirl.create(:page, :link_url => "/")
      FactoryGirl.create(:page, :title => "test")
    end

    describe "#home" do
      it "renders home template" do
        get :home
        expect(response).to render_template("home")
      end
    end

    describe "#show" do
      it "renders show template" do
        get :show, params: {path: "test"}
        expect(response).to render_template("show")
      end
    end
  end
end
