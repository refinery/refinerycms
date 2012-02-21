require "spec_helper"

describe "Refinery::ApplicationController" do
  describe "DummyController", :type => :controller do
    controller do
      include ::Refinery::ApplicationController
    end

    describe ".home_page?" do
<<<<<<< HEAD
=======
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

>>>>>>> b51f8da0af340f7f06e76d2d760ad789ebed5ce4
      it "escapes regexp" do
        request.stub(:path).and_return("\/huh)")
        expect { controller.home_page? }.to_not raise_error(RegexpError)
      end
    end
  end
end
