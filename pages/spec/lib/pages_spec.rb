require "spec_helper"

module Refinery
  describe Pages do
    describe ".valid_templates" do
      before do
        File.open(File.join(subject.root, "spec", "ugisozols.html"), "w+") do
        end
      end

      after { File.delete(File.join(subject.root, "spec", "ugisozols.html")) }

      context "when pattern match valid templates" do
        it "returns an array of valid templates" do
          subject.valid_templates('spec', '*html*').should include("ugisozols")
        end
      end

      context "when pattern doesn't match valid templates" do
        it "returns empty array" do
          subject.valid_templates('huh', '*html*').should == []
        end
      end
    end
    
    describe ".default_parts_for" do
      before do
        @page = FactoryGirl.create :page
      end
      
      it "returns default parts for page without view_template" do
        subject.default_parts_for(@page).should == Refinery::Pages.default_parts
      end
      
      it "return default parts for page with view_template which does not have configured parts" do
        @page.view_template = "view_template_with_no_parts_configured"
        subject.default_parts_for(@page).should == Refinery::Pages.default_parts
      end
      
      it "return default parts for page with view_template which does have configured parts" do
        subject.configure do |config|
          config.types.register :view_template_with_parts_configured do |template|
            template.parts = %w[first second third]
          end
        end
        @page.view_template = "view_template_with_parts_configured"
        subject.default_parts_for(@page).should == %w[First Second Third]
      end
    end

  end
end
