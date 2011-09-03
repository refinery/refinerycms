# encoding: utf-8
require "spec_helper"

describe "translate pages" do
  before(:each) do
    FactoryGirl.create(:refinery_user)
    user = FactoryGirl.create(:refinery_translator, :password => "123456",
                                         :password_confirmation => "123456")

    visit new_refinery_user_session_path

    fill_in "Login", :with => user.username
    fill_in "Password", :with => "123456"
    click_button "Sign in"
  end

  describe "add page to main locale" do
    it "should not succeed" do
      visit refinery_admin_pages_path

      click_link "Add new page"

      fill_in "Title", :with => "Huh?"
      click_button "Save"

      page.should have_content("You do not have the required permission to modify pages in this language")
    end
  end

  describe "add page to second locale" do
    before(:each) do
      Refinery::I18n.stub(:frontend_locales).and_return([:en, :lv])
      FactoryGirl.create(:page)
    end

    it "should succeed" do
      visit refinery_admin_pages_path

      click_link "Add new page"

      within "#switch_locale_picker" do
        click_link "Lv"
      end
      fill_in "Title", :with => "Brīva vieta reklāmai"
      click_button "Save"

      page.should have_content("'Brīva vieta reklāmai' was successfully added.")
      Refinery::Page.count.should == 2
    end
  end

  describe "delete page from main locale" do
    before(:each) { FactoryGirl.create(:page) }

    it "should not succeed" do
      visit refinery_admin_pages_path

      click_link "Remove this page forever"

      page.should have_content("You do not have the required permission to modify pages in this language.")
      Refinery::Page.count.should == 1
    end
  end
end
