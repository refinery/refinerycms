require 'spec_helper'

describe 'page frontend' do

  before(:all) do
    # Create a refinery user unless we have one.
    Factory.create :refinery_user if ::Refinery::Role[:refinery].users.empty?

    # Delete all pages and their slugs.
    ::Refinery::Page.all.each(&:destroy!)

    # Create some pages for these specs
    ::Refinery::Page.create(:title => 'Home', :link_url => '/')
    ::Refinery::Page.create(:title => 'About')
    ::Refinery::Page.create(:title => 'Draft', :draft => true)
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

end
