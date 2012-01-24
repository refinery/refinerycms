require "spec_helper"

describe "dashboard" do
  login_refinery_user

  describe "quick tasks" do
    specify "buttons" do
      visit refinery_admin_dashboard_path

      page.should have_content("Quick Tasks")

      # add new page
      page.should have_content("Add a new page")
      page.should have_selector("a[href='/refinery/pages/new']")

      # update page
      page.should have_content("Update a page")
      page.should have_selector("a[href='/refinery/pages']")

      # upload file
      if defined? Refinery::Resource
        page.should have_content("Upload a file")
        page.should have_selector("a[href*='/refinery/resources/new']")
      end

      # upload image
      if defined? Refinery::Image
        page.should have_content("Upload an image")
        page.should have_selector("a[href*='/refinery/images/new']")
      end
    end
  end

  describe "latest activity" do
    before(:each) do
      3.times { |n| FactoryGirl.create(:refinery_user, :username => "ugisozols#{n}") }
      3.times { |n| FactoryGirl.create(:page, :title => "Refinery CMS #{n}") }
    end

    it "shows 7 recent actions" do
      visit refinery_admin_dashboard_path

      page.should have_content("Latest Activity")
      # This comes from login_refinery_user
      page.should have_content("Refinerycms user was")
      3.times { |n| page.should have_content("Ugisozols#{n} user was added") }
      3.times { |n| page.should have_content("Refinery cms #{n} page was added") }
    end
  end
end
