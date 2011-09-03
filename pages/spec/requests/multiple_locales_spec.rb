# encoding: utf-8
require "spec_helper"

describe "pages with translations" do
  login_refinery_user

  before(:each) do
    ::Refinery::Setting.set(:i18n_translation_frontend_locales,
                           {:value => [:en, :ru], :scoping => 'refinery'})

    # Create a home page in both locales (needed to test menus)
    home_page =  ::Refinery::Page.create!(:title => 'Home', :link_url => '/', :menu_match => "^/$")
    Globalize.locale = :ru
    home_page.title = 'Домашняя страница'
    home_page.save
    Globalize.locale = :en
  end

  describe "add a page with title for default locale" do
    before do
      visit refinery_admin_pages_path
      click_link "Add new page"
      fill_in "Title", :with => "News"
      click_button "Save"
    end

    it "should succeed" do
      page.should have_content("'News' was successfully added.")
      Refinery::Page.count.should == 2
    end

    it "should show locale flag for page" do
      p = ::Refinery::Page.find('news')
      within "#refinery_page_#{p.id}" do
        page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
      end
    end

    it "should show title in the admin menu" do
      p = ::Refinery::Page.find('news')
      within "#refinery_page_#{p.id}" do
        page.should have_content('News')
        page.find_link('Edit this page')[:href].should include('news')
      end
    end

    it "should show in frontend menu for 'en' locale" do
      visit "/"

      within "#menu" do
        page.should have_content('News')
        page.should have_css('a', :href => 'news')
      end
    end

    it "should not show in frontend menu for 'ru' locale" do
      visit "/ru"

      within "#menu" do
        # we should only have the home page in the menu
        page.should have_css('li', :count => 1)
      end
    end
  end

  describe "add a page with title for both locales" do
    before do
      visit refinery_admin_pages_path
      click_link "Add new page"
      within "#switch_locale_picker" do
        click_link "Ru"
      end
      fill_in "Title", :with => "Новости"
      click_button "Save"

      p = ::Refinery::Page.last
      within "#refinery_page_#{p.id}" do
        click_link "Application_edit"
      end
      within "#switch_locale_picker" do
        click_link "En"
      end
      fill_in "Title", :with => "News"
      click_button "Save"
    end

    it "should succeed" do
      page.should have_content("'News' was successfully updated.")
      Refinery::Page.count.should == 2
    end

    it "should show both locale flags for page" do
      p = ::Refinery::Page.find('news')
      within "#refinery_page_#{p.id}" do
        page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
        page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
      end
    end

    it "should show title in admin menu in current admin locale" do
      p = ::Refinery::Page.find('news')
      within "#refinery_page_#{p.id}" do
        page.should have_content('News')
      end
    end

    it "should use the slug from the default locale in admin" do
      p = ::Refinery::Page.find('news')
      within "#refinery_page_#{p.id}" do
        page.find_link('Edit this page')[:href].should include('news')
      end
    end

    it "should show correct language and slugs for default locale" do
      visit "/"

      within "#menu" do
        page.find_link('News')[:href].should include('news')
      end
    end

    it "should show correct language and slugs for second locale" do
      visit "/ru"

      within "#menu" do
        page.find_link('Новости')[:href].should include('%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8')
      end
    end
  end

  describe "add a page with title only for secondary locale" do
    before do
      visit refinery_admin_pages_path
      click_link "Add new page"
      within "#switch_locale_picker" do
        click_link "Ru"
      end
      fill_in "Title", :with => "Новости"
      click_button "Save"
    end

    it "should succeed" do
      page.should have_content("'Новости' was successfully added.")
      Refinery::Page.count.should == 2
    end

    it "should show locale flag for page" do
      p = ::Refinery::Page.find('новости')
      within "#refinery_page_#{p.id}" do
        page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
      end
    end

    it "should not show locale flag for primary locale" do
      p = ::Refinery::Page.find('новости')
      within "#refinery_page_#{p.id}" do
        page.should_not have_css("img[src='/assets/refinery/icons/flags/en.png']")
      end
    end

    it "should show title in the admin menu" do
      p = ::Refinery::Page.find('новости')
      within "#refinery_page_#{p.id}" do
        page.should have_content('Новости')
      end
    end

    it "should use use ID instead of slug in admin" do
      p = ::Refinery::Page.find('новости')
      within "#refinery_page_#{p.id}" do
        page.find_link('Edit this page')[:href].should include(p.id.to_s)
      end
    end

    it "should show in frontend menu for 'ru' locale" do
      visit "/ru"

      within "#menu" do
        page.should have_content('Новости')
        page.should have_css('a', :href => 'новости')
      end
    end

    it "should not show in frontend menu for 'en' locale" do
      visit "/"

      within "#menu" do
        # we should only have the home page in the menu
        page.should have_css('li', :count => 1)
      end
    end
  end

end
