require "spec_helper"

module Refinery
  describe ApplicationController, :type => :controller do
    before do
      Rails.application.routes.draw {
        mount Refinery::Core::Engine, :at => '/'
        get "anonymous/index"
      }
    end

    after do
      Rails.application.reload_routes!
    end

    controller(ActionController::Base) do
      include ::Refinery::ApplicationController

      def index
        head :ok
      end
    end

    describe ".home_page?" do
      it "matches root url" do
        allow(controller).to receive(:root_path).and_return("/")
        allow(request).to receive(:path).and_return("/")
        expect(controller.home_page?).to be_truthy
      end

      it "matches localised root url" do
        allow(controller.refinery).to receive(:root_path).and_return("/en/")
        allow(request).to receive(:path).and_return("/en")
        expect(controller.home_page?).to be_truthy
      end

      it "matches localised root url with trailing slash" do
        allow(controller.refinery).to receive(:root_path).and_return("/en/")
        allow(request).to receive(:path).and_return("/en/")
        expect(controller.home_page?).to be_truthy
      end

      it "escapes regexp" do
        allow(request).to receive(:path).and_return("\/huh)")
        expect { controller.home_page? }.to_not raise_error
      end

      it "returns false for non root url" do
        allow(request).to receive(:path).and_return("/foo/")
        expect(controller).not_to be_home_page
      end
    end

    describe "#presenter_for" do
      it "returns BasePresenter for nil" do
        expect(controller.send(:presenter_for, nil)).to eq(BasePresenter)
      end

      it "returns BasePresenter when the instance's class does not have a presenter" do
        expect(controller.send(:presenter_for, Object.new)).to eq(BasePresenter)
      end

      it "returns the class's presenter when the instance's class has a presenter" do
        model = Refinery::Page.new
        expect(controller.send(:presenter_for, model)).to eq(Refinery::PagePresenter)
      end
    end
  end
end
