require "spec_helper"

module Refinery
  describe ApplicationController do
    describe "DummyController", :type => :controller do
      before do
        Rails.application.routes.draw { get "anonymous/index" }
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

        it "escapes regexp" do
          request.stub(:path).and_return("\/huh)")
          expect { controller.home_page? }.to_not raise_error(RegexpError)
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
          controller.send(:presenter_for, Page.new).should eq(PagePresenter)
        end
      end

      describe "force_ssl" do
        before(:each) do
          controller.stub(:admin?).and_return(true)
          controller.stub(:refinery_user_required?).and_return(false)
        end

        it "is false so standard HTTP is used" do
          Refinery::Core.config.force_ssl = false

          get :index

          response.should_not be_redirect
        end

        it "is true so HTTPS is used" do
          begin
            Refinery::Core.config.force_ssl = true

            get :index

            response.should be_redirect
          ensure
            Refinery::Core.config.force_ssl = false
          end
        end
      end

    end
  end
end
