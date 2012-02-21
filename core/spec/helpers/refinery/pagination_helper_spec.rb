require "spec_helper"

module Refinery
  describe PaginationHelper do

    describe "#pagination_css_class" do
      context "when request.xhr? and params[:from_page] is set" do
        before(:each) do
          controller.request.stub(:xhr?).and_return(true)
        end

        context "when params[:from_page] > params[:page] or 1" do
          it "does something" do
            helper.stub(:params).and_return({:from_page => 2, :page => 1})
            helper.pagination_css_class.should == "frame_left"
          end
        end

        context "when params[:from_page] < params[:page] or 1" do
          it "returns frame_right" do
            helper.stub(:params).and_return({:from_page => 1, :page => 1})
            helper.pagination_css_class.should == "frame_right"
          end
        end
      end

      context "when request.xhr? and params[:from_page] isn't set" do
        it "returns frame_center" do
          helper.pagination_css_class.should == "frame_center"
        end
      end
    end

  end
end
