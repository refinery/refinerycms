# encoding: utf-8
require 'spec_helper'

describe 'page frontend' do
  before(:each) do
    # So that we can use Refinery.
    Factory(:refinery_user)

    # Create some pages for these specs
    Factory(:page, :title => 'Home', :link_url => '/')
    Factory(:page, :title => 'About')
    Factory(:page, :title => 'Draft', :draft => true)
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

  describe 'when a page has multiple friendly_id slugs' do
    before(:each) do
      # Create a page, then change the page title, creating a new slug
      news_page = Factory(:page, :title => "News")
      news_page.title = "Recent News"
      news_page.save
    end

    describe 'page accessed via current slug' do
      it 'shows the page' do
        visit '/recent-news'

        standard_page_menu_items_exist?
      end
    end

    describe 'page is access via old slug' do
      it '301 redirects to current url' do
        visit '/news'

        # capybara follows the 301 redirect to the current url
        current_path.should == '/recent-news'
      end
    end
  end

  describe 'when menu_title is' do
    let!(:special_page) { Factory(:page, :title => 'Company News') }
    
    describe 'set' do
      before do
        special_page.menu_title = "News"
        special_page.save
      end
      
      it 'shows the menu_title in the menu and changes the slug' do
        visit '/news'
        within ".selected" do
          page.should have_content("News")
        end
      end
    end

    describe 'not set' do
      it 'the slug and menu title are not changed' do
        visit '/company-news'
        within ".selected" do
          page.should have_content("Company News")
        end
      end
    end

    describe 'set and then unset' do
      before(:each) do 
        special_page.menu_title = "News"
        special_page.save
        special_page.menu_title = ""
        special_page.save
      end

      it 'the slug and menu are reverted to match the title' do
        visit '/company-news'
        within ".selected" do
          page.should have_content("Company News")
        end
      end
      
      it '301 redirects to current url' do
        visit '/news'
        # capybara follows the 301 redirect to the current url
        current_path.should == '/company-news'
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
    let(:special_page) { Factory(:page, :title => 'ä ö ü spéciål chåråctÉrs') }

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
    let(:special_page) { Factory(:page, :title => 'ä ö ü spéciål chåråctÉrs',
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
    let(:hidden_page) { Factory(:page, :title => "Hidden", :show_in_menu => false) }

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
     Factory(:page, :title => "Child Page", :parent_id => about.id)
    end

    it "succeeds" do
      visit "/about"

      within ".selected * > .selected a" do
        page.should have_content("Child Page")
      end
    end
  end
end
