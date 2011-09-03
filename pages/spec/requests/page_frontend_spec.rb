# encoding: utf-8
require 'spec_helper'

describe 'page frontend' do
  before(:each) do
    # So that we can use Refinery.
    FactoryGirl.create(:refinery_user)

    # Create some pages for these specs
    FactoryGirl.create(:page, :title => 'Home', :link_url => '/')
    FactoryGirl.create(:page, :title => 'About')
    FactoryGirl.create(:page, :title => 'Draft', :draft => true)
  end

  def standard_page_menu_items_exist?
    within('.menu') do
      page.should have_content("Home")
      page.should have_content("About")
      page.should_not have_content("Draft")
    end
  end

  describe 'when marketable urls are' do
    describe 'enabled' do
      before { ::Refinery::Pages.stub(:use_marketable_urls?).and_return(true) }

      it 'shows the homepage' do
        visit '/'

        standard_page_menu_items_exist?
      end

      it 'shows a show page' do
        visit url_for(::Refinery::Page.find('about').url)

        standard_page_menu_items_exist?
      end
    end

    describe 'disabled' do
      before { ::Refinery::Pages.stub(:use_marketable_urls?).and_return(false) }

      it 'shows the homepage' do
        visit '/'

        standard_page_menu_items_exist?
      end

      it 'does not route to /about for About page' do
        url_for(::Refinery::Page.find('about').url).should =~ %r{/pages/about$}
      end

      it 'shows the about page' do
        visit url_for(::Refinery::Page.find('about').url)

        standard_page_menu_items_exist?
      end
    end
  end

  describe 'title set (without menu title or browser title)' do
    it "shows title at the top of the page" do
      visit "/about"

      find("#body_content_title").text.should == "About"
    end

    it "uses title in the menu" do
      visit "/about"

      find(".selected").text.strip.should == "About"
    end

    it "uses title in browser title" do
      visit "/about"

      find("title").should have_content("About")
    end
  end

  describe 'when menu_title is' do
    let!(:page_mt) { FactoryGirl.create(:page, :title => 'Company News') }

    describe 'set' do
      before do
        page_mt.menu_title = "News"
        page_mt.save
      end

      it 'changes the friendly_id and redirects the old one' do
        visit '/company-news'

        current_path.should == '/news'
      end

      it 'shows the menu_title in the menu' do
        visit '/news'

        find(".selected").text.strip.should == "News"
      end

      it "does not effect browser title and page title" do
        visit "/news"

        find("title").should have_content("Company News")
        find("#body_content_title").text.should == "Company News"
      end
    end

    describe 'set and then unset' do
      before do
        page_mt.menu_title = "News"
        page_mt.save
        page_mt.menu_title = ""
        page_mt.save
      end

      it 'the friendly_id and menu are reverted to match the title' do
        visit '/company-news'

        current_path.should == '/company-news'
        find(".selected").text.strip.should == "Company News"
      end

      it '301 redirects old friendly_id to current url' do
        visit '/news'

        current_path.should == '/company-news'
      end
    end
  end

  describe 'when browser_title is set' do
    let!(:page_bt) { FactoryGirl.create(:page, :title => 'About Us', :browser_title => 'About Our Company') }

    it 'should have the browser_title in the title tag' do
      visit '/about-us'

      page.find("title").text == "About Our Company"
    end

    it 'should not effect page title and menu title' do
      visit '/about-us'

      find("#body_content_title").text.should == "About Us"
      find(".selected").text.strip.should == "About Us"
    end
  end

  describe 'custom_slug' do
    let!(:page_cs) { FactoryGirl.create(:page, :title => 'About Us') }

    describe 'not set' do
      it 'makes friendly_id from title' do
        visit '/about-us'

        current_path.should == '/about-us'
      end
    end

    describe 'set' do
      before do
        page_cs.custom_slug = "about-custom"
        page_cs.save
      end

      it 'should make and use a new friendly_id' do
        visit '/about-custom'

        current_path.should == '/about-custom'
      end

      it 'old url should 301 redirect to current url' do
        visit '/about-us'

        current_path.should == '/about-custom'
      end
    end

    describe 'set and unset' do
      before do
        page_cs.custom_slug = "about-custom"
        page_cs.save
        page_cs.custom_slug = ""
        page_cs.save
        page_cs.reload
      end

      it 'should revert to old friendly_id and redirect' do
        visit '/about-custom'

        current_path.should == '/about-us'
      end
    end
  end

  # Following specs are converted from one of the cucumber features.
  # Maybe we should clean up this spec file a bit...
  describe "home page" do
    it "succeeds" do
      visit "/"

      within ".selected" do
        page.should have_content("Home")
      end
      page.should have_content("About")
    end
  end

  describe "content page" do
    it "succeeds" do
      visit "/about"

      page.should have_content("Home")
      within ".selected > a" do
        page.should have_content("About")
      end
    end
  end

  describe "special characters title" do
    let(:special_page) { FactoryGirl.create(:page, :title => 'ä ö ü spéciål chåråctÉrs') }

    it "succeeds" do
      visit url_for(special_page.url)

      page.should have_content("Home")
      page.should have_content("About")
      within ".selected > a" do
        page.should have_content("ä ö ü spéciål chåråctÉrs")
      end
    end
  end

  describe "special characters title as submenu page" do
    let(:special_page) { FactoryGirl.create(:page, :title => 'ä ö ü spéciål chåråctÉrs',
                                        :parent_id => Refinery::Page.find("about").id) }

    it "succeeds" do
      visit url_for(special_page.url)

      page.should have_content("Home")
      page.should have_content("About")
      within ".selected * > .selected a" do
        page.should have_content("ä ö ü spéciål chåråctÉrs")
      end
    end
  end

  describe "hidden page" do
    let(:hidden_page) { FactoryGirl.create(:page, :title => "Hidden", :show_in_menu => false) }

    it "succeeds" do
      visit url_for(hidden_page.url)

      page.should have_content("Home")
      page.should have_content("About")
      page.should have_content("Hidden")
      within "nav" do
        page.should have_no_content("Hidden")
      end
    end
  end

  describe "skip to first child" do
    before(:each) do
     about = Refinery::Page.find('about')
     about.skip_to_first_child = true
     about.save!
     FactoryGirl.create(:page, :title => "Child Page", :parent_id => about.id)
    end

    it "succeeds" do
      visit "/about"

      within ".selected * > .selected a" do
        page.should have_content("Child Page")
      end
    end
  end
end
