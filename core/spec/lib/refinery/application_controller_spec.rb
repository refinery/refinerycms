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

    controller do
      include ::Refinery::ApplicationController

      def index
        render :nothing => true
      end
    end

    describe ".home_page?" do
      it "matches root url" do
        controller.stub(:root_path).and_return("/")
        request.stub(:path).and_return("/")
        controller.home_page?.should be_true
      end

      it "matches localised root url" do
        controller.refinery.stub(:root_path).and_return("/en/")
        request.stub(:path).and_return("/en")
        controller.home_page?.should be_true
      end

      it "matches localised root url with trailing slash" do
        controller.refinery.stub(:root_path).and_return("/en/")
        request.stub(:path).and_return("/en/")
        controller.home_page?.should be_true
      end

      it "escapes regexp" do
        request.stub(:path).and_return("\/huh)")
        expect { controller.home_page? }.to_not raise_error(RegexpError)
      end

      it "returns false for non root url" do
        request.stub(:path).and_return("/foo/")
        controller.should_not be_home_page
      end
    end

    describe "#presenter_for" do
      it "returns BasePresenter for nil" do
        controller.send(:presenter_for, nil).should eq(BasePresenter)
      end

      it "returns BasePresenter when the instance's class does not have a presenter" do
        controller.send(:presenter_for, Object.new).should eq(BasePresenter)
      end

      it "returns the class's presenter when the instance's class has a presenter" do
        model = Refinery::Page.new
        controller.send(:presenter_for, model).should eq(Refinery::PagePresenter)
      end
    end
  end
end
