require "spec_helper"

module Refinery
  describe "browser title" do
    describe "HTML entities" do
      it "displays the site name correctly" do
        RefinerySetting.set(:site_name, "&<>")
        visit root_path
        title = find("title")
        RefinerySetting.set(:site_name, nil)
        title.should have_content("&<>")
      end
      
#      it "displays the meta browser title correctly" do
#        haven't been able to figure out how to set the @meta.browser_title
#      end
      
#      it "displays content for yield :title correctly" do
#        haven't been able to figure out how to provide content_for :title
#      end
    end
  end
end
