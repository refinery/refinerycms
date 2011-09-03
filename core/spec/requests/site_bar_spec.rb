require "spec_helper"

describe "site bar" do
  login_refinery_user

  it "have logout link" do
    page.should have_content("Log out")
    page.should have_selector("a[href='/refinery/users/logout']")
  end

  context "when in backend" do
    before(:each) do
      visit refinery_admin_dashboard_path
    end

    it "have a 'switch to your website button'" do
      page.should have_content("Switch to your website")
      page.should have_selector("a[href='/']")
    end

    it "switches to frontend" do
      page.current_path.should == refinery_admin_dashboard_path
      click_link "Switch to your website"
      page.current_path.should == root_path
    end
  end

  context "when in frontend" do
    before(:each) do
      # make a page in order to avoid 404
      FactoryGirl.create(:page, :link_url => "/")

      visit root_path
    end

    it "have a 'switch to your website editor' button" do
      page.should have_content("Switch to your website editor")
      page.should have_selector("a[href='/refinery']")
    end

    it "switches to backend" do
      page.current_path.should == root_path
      click_link "Switch to your website editor"
      page.current_path.should == refinery_admin_root_path
    end
  end
end
