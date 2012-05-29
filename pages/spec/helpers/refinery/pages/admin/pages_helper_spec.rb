require "spec_helper"

module Refinery
  module Admin
    describe PagesHelper do
      describe "#view_template_options" do
        context "when page layout/view templte is set" do
          it "returns empty hash" do
            page = FactoryGirl.create(:page)

            page.view_template = "rspec_template"
            helper.view_template_options(:view_template, page).should eq({})

            page.layout_template = "rspec_layout"
            helper.view_template_options(:layout_template, page).should eq({})
          end
        end

        context "when page layout/view template isn't set" do
          context "when page has parent" do
            it "returns option hash based on parent page" do
              parent = FactoryGirl.create(:page, :view_template => "rspec_view",
                                                 :layout_template => "rspec_layout")
              page = FactoryGirl.create(:page, :parent_id => parent.id)

              expected_view = { :selected => parent.view_template }
              helper.view_template_options(:view_template, page).should eq(expected_view)

              expected_layout = { :selected => parent.layout_template }
              helper.view_template_options(:layout_template, page).should eq(expected_layout)
            end
          end

          context "when page doesn't have parent page" do
            before do
              Refinery::Pages.stub(:view_template_whitelist).and_return(%w(one two))
              Refinery::Pages.stub(:layout_template_whitelist).and_return(%w(two one))
            end

            it "returns option hash with first item from configured whitelist" do
              page = FactoryGirl.create(:page)

              expected_view = { :selected => "one" }
              helper.view_template_options(:view_template, page).should eq(expected_view)

              expected_layout = { :selected => "two" }
              helper.view_template_options(:layout_template, page).should eq(expected_layout)
            end
          end
        end
      end
    end
  end
end 
