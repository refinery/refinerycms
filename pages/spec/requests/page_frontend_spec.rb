require 'spec_helper'

describe 'page frontend' do
  login_refinery_user

  before(:each) do
    # Create some pages for these specs
    Factory(:page, :title => 'Home', :link_url => '/')
    Factory(:page, :title => 'About')
    Factory(:page, :title => 'Draft', :draft => true)
  end

  describe 'when marketable urls are' do
    describe 'enabled' do
      before { ::Refinery::Pages.stub(:use_marketable_urls?).and_return(true) }

      it 'shows the homepage' do
        visit '/'
      end

      it 'shows a show page' do
        visit url_for(::Refinery::Page.find('about').url)
      end
    end

    describe 'disabled' do
      before { ::Refinery::Pages.stub(:use_marketable_urls?).and_return(false) }

      it 'shows the homepage' do
        visit '/'
      end

      it 'does not route to /about for About page' do
        url_for(::Refinery::Page.find('about').url).should =~ %r{/pages/about$}
      end
    end
  end

  describe 'when a page has multiple friendly_id slugs' do
    before(:each) do
      # Create a page, then change the page title, creating a new slug
      page = Factory(:page, :title => "News")
      page.title = "Recent News"
      page.save
    end

    describe 'page accessed via current slug' do
      it 'shows the page' do
        visit '/recent-news'
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
end
