require "spec_helper"

describe "manage resources" do
  login_refinery_user

  before(:each) { visit refinery_admin_resources_path }

  context "when no files" do
    it "invites to upload file" do
      page.should have_content("There are no files yet. Click \"Upload new file\" to add your first file.")
    end
  end

  it "shows upload file link" do
    page.should have_content("Upload new file")
    page.should have_selector("a[href*='/refinery/resources/new']")
  end

  it "uploads file", :js => true do
    click_link "Upload new file"

    within_frame "dialog_iframe" do
      attach_file "resource_file", File.expand_path("../../uploads/refinery_is_awesome.txt", __FILE__)
      click_button "Save"
    end

    page.should have_content("Refinery Is Awesome.txt")
  end
end
