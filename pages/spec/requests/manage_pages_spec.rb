require "spec_helper"

describe "manage pages" do
  login_refinery_user

  context "when no pages" do
    it "invites to create one" do
      visit refinery_admin_pages_path
      page.should have_content("There are no pages yet. Click \"Add new page\" to add your first page.")
    end
  end

  describe "action links" do
    it "shows add new page link" do
      visit refinery_admin_pages_path

      within "#actions" do
        page.should have_content("Add new page")
        page.should have_selector("a[href='/refinery/pages/new']")
      end
    end

    context "when no pages" do
      it "doesn't show reorder pages link" do
        visit refinery_admin_pages_path

        within "#actions" do
          page.should have_no_content("Reorder pages")
          page.should have_no_selector("a[href='/refinery/pages']")
        end
      end
    end

    context "when some pages exist" do
      before(:each) { 2.times { FactoryGirl.create(:page) } }

      it "shows reorder pages link" do
        visit refinery_admin_pages_path

        within "#actions" do
          page.should have_content("Reorder pages")
          page.should have_selector("a[href='/refinery/pages']")
        end
      end
    end
  end

  describe "new/create" do
    it "allows to create page" do
      visit refinery_admin_pages_path

      click_link "Add new page"

      fill_in "Title", :with => "My first page"
      click_button "Save"

      page.should have_content("'My first page' was successfully added.")
      # TODO: figure out why these matchers fail?
      # page.should have_content("Remove this page forever")
      # page.should have_selector("a[href='/refinery/pages/my-first-page']")
      # page.should have_content("Edit this page")
      # page.should have_selector("a[href='/refinery/pages/my-first-page/edit']")
      # page.should have_content("Add a new child page")
      # page.should have_selector("a[href*='/refinery/pages/new?parent_id=']")
      # page.should have_content("View this page live")
      # page.should have_selector("a[href='/pages/my-first-page']")
      page.body.should =~ /Remove this page forever/
      page.body.should =~ /Edit this page/
      page.body.should =~ /\/refinery\/pages\/my-first-page\/edit/
      page.body.should =~ /Add a new child page/
      page.body.should =~ /\/refinery\/pages\/new\?parent_id=/
      page.body.should =~ /View this page live/
      page.body.should =~ /\/pages\/my-first-page/

      Refinery::Page.count.should == 1
    end
  end

  describe "edit/update" do
    before(:each) { FactoryGirl.create(:page, :title => "Update me") }

    it "updates page" do
      visit refinery_admin_pages_path

      page.should have_content("Update me")

      click_link "Edit this page"

      fill_in "Title", :with => "Updated"
      click_button "Save"

      page.should have_content("'Updated' was successfully updated.")
    end
  end

  describe "destroy" do
    context "when page can be deleted" do
      before(:each) { FactoryGirl.create(:page, :title => "Delete me") }

      it "will show delete button" do
        visit refinery_admin_pages_path

        click_link "Remove this page forever"

        page.should have_content("'Delete me' was successfully removed.")

        Refinery::Page.count.should == 0
      end
    end

    context "when page can't be deleted" do
      before(:each) { FactoryGirl.create(:page, :title => "Indestructible",
                                     :deletable => false) }

      it "wont show delete button" do
        visit refinery_admin_pages_path

        page.should have_no_content("Remove this page forever")
        page.should have_no_selector("a[href='/refinery/pages/indestructible']")
      end
    end
  end

  context "duplicate page titles" do
    before(:each) { FactoryGirl.create(:page, :title => "I was here first") }

    it "will append nr to url path" do
      visit new_refinery_admin_page_path

      fill_in "Title", :with => "I was here first"
      click_button "Save"

      Refinery::Page.last.url[:path].should == ["i-was-here-first--2"]
    end
  end
end
